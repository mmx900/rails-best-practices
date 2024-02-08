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
