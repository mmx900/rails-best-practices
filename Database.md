### 데이터베이스의 선택

DDL 트랜잭션이 잘 지원되는 DB를 사용하면, 레일즈 마이그레이션 실행시 수작업을 할 일이 줄어든다. 예를 들면, 테이블 생성 혹은 변경과 추가적인 Insert문 등을 넣어둔 마이그레이션이 중간에 실패할 경우, 마이그레이션이 동작하지 않은 것으로 기록되는건 동일하지만, DDL 트랜잭션이 잘 지원되지 않는 경우 Create 문 등이 롤백되지 않아 이후 재시도시 이미 같은 테이블이 있다는 등의 오류를 마주하게 된다. 몇몇 라인을 주석처리하고 실행하거나 생성된 내용을 수동으로 지우거나 할 수는 있지만 개발환경에선 번거롭고 실서버에서는 위험하다. 경험상 MySQL8보다 PostgreSQL이 DDL 트랜잭션 지원이 잘 되었다.

또한 PostgreSQL의 경우 색인시 `algorithm: :concurrently`가 지원되기 때문에 [MySQL보다 수월하게 인덱스를 추가](https://stackoverflow.com/a/70858410)할 수 있다. 보통 속도에 문제가 생겼을 정도로 많은 데이터가 쌓였을 때 새로운 인덱스 추가가 고려되기 때문에 매우 유용하다.

MySQL의 경우 [Rails 7에서 추가된 `nulls_last()`를 사용할 수 없기도 하다](https://blog.saeloun.com/2021/10/12/support-nulls_first-for-all-databases/).

### N+1 문제

[Prosopite](https://github.com/charkost/prosopite) 같은 젬을 사용하면 로그에서 경고를 보는 것에서 예외를 발생시켜 프로그램을 중단시키는 것 까지 가능하자. 프로젝트 시작시 미리 세팅해두자.

#### lint

[양방향 관계](https://guides.rubyonrails.org/association_basics.html#bi-directional-associations)에 대해 이해하면 추가적인 쿼리를 줄일 수 있다. standard-rails(rubocop-rails)의 [Rails/InverseOf](https://www.rubydoc.info/gems/rubocop/0.61.1/RuboCop/Cop/Rails/InverseOf) 같은 Cop은 이 문제를 파악할 수 있게 해준다.

### MySQL

보통 많이 사용하는 것이 `order by created_at desc, id desc` 인데 적절한 인덱스를 생성해두지 않으면 Filescan, Backward Index Scan 이 되어 레코드가 많아질수록 느려진다. 정렬순서를 포함해 다음처럼 추가할 수 있다.

```ruby
add_index :articles, [:created_at, :id], order: {created_at: :desc, id: :desc}, comment: "최근글 조회"
```

적용 결과는 `explain`문으로 알 수 있다.

```sql
explain select * from articles order by created_at desc, id desc limit 25; --limit 절이 없으면 인덱스를 활용하지 않는다.
```

### Row Count

```sql
select count(*) from articles;
```

위와 같은 카운트 쿼리는 의외로 비용이 많이 든다. 보통 사용하는 MySQL의 InnoDB는 내부적으로 Row Count를 저장하지 않기 때문이다. 내장 카운트 캐시나 counter culture같은 젬은 연관된 레코드를 보유한 레코드에만 사용 가능하다. 이를 해소하려면 캐시나 별도의 테이블을 활용해야 한다.

* 참고 : [How to count SQL databases quickly in PostgreSQL and MySQL - New Relic](https://newrelic.com/blog/how-to-relic/fast-counting-in-postgresql-and-mysql)

### Lint

rubocop-rails 는 DB 선언 내용도 살펴보므로 초기부터 적용하면 도움이 된다. 예를 들면, boolean 필드에 `not null`을 선언하지 않으면 세 가지 상태를 가질 수 있는 위험이 있는데 다음처럼 예방해준다.

```
db/schema.rb:1705:5: C: Rails/ThreeStateBooleanColumn: Boolean columns should always have a default value and a NOT NULL constraint.
    t.boolean "email_confirmed", default: false
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
```

### 데이터 타입

* URL 유형 : https://github.com/perfectline/validates_url
* URL은 문자열 그대로 다루지 않고 항상 `Addressable::URI.parse(url)&.normalize&.to_s` 정도로 처리를 해두면 여러 오류를 피해갈 수 있다. ([참고](https://github.com/sporkmonger/addressable?tab=readme-ov-file#example-usage)) 예를 들자면 레일스 기본 API를 사용해 `OpenURI.open_uri(url)`같은 코드를 쓸 일이 있는 경우, 한글이 들어간 URL을 사용시 `URI::InvalidURIError (URI must be ascii only)`를 맞닥뜨리게 되지만 위에서 사용한 `normalize`를 사용하면 피해갈 수 있다.

#### Date 필드

[HTML에서 Date 유형의 Input 요소](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/date)는 "yyyy-mm-dd" 형식의 값을 갖는다. 이를 datetime 유형으로 선언된 속성(attribute)에 할당하는 것은 기본적으로 문제가 되지 않는다. 그러나 다음처럼 정제(normalization)나 검증(validation)이 필요한 경우가 생길 수 있다.

 * Datetime으로 파싱할 수 없는 잘못된 입력이 발생하는 경우
   datetime 유형의 컬럼에 임의의 문자열 같은 잘못된 값을 할당해보면, 그냥 nil이 할당된다. [이는 type case 과정을 거치게 되기 때문이다.](https://api.rubyonrails.org/v7.1.3.1/classes/ActiveRecord/Base.html#class-ActiveRecord::Base-label-Accessing+attributes+before+they+have+been+typecasted) 문제는 이때 저장을 하면 모델의 errors 속성에 에러가 추가되기를 기대하겠지만 그렇게 되지 않는다는 것이다. 이러면 클라이언트쪽의 문제를 발견하기 어렵고, 원치 않게 값을 저장하게 될 수도 있다.
   `(attrname)_before_type_case`를 활용하는 방법이 있다. [참고](https://stackoverflow.com/questions/1370926/rails-built-in-datetime-validation)
 * 시분초를 제외하고 연월일만 저장하고 싶은 경우
   date 유형으로 바꾸지 않고 datetime에서 연월일만 저장하고 싶다면 레일스 7.1에 추가된 normalize를 활용할 수 있다.
   ```ruby
   normalizes :published_at, with: ->(published_at) { published_at&.beginning_of_day }
   ```
