### enum

[enum](https://api.rubyonrails.org/classes/ActiveRecord/Enum.html)은 문자열로 선언한다. 숫자로 선언하는 경우 다음과 같은 문제가 있다.

* DB 테이블만 보고서 유추하기 어렵다.
* 일종의 진행상태를 나타내는 경우(0: 신청됨, 1: 처리됨) 중간에 다른 상태가 들어가는 변경이 필요한 경우 마이그레이션이 어려울 수 있다. 진행상태가 아니더라도, 보통 순서에는 중요도 등 어떠한 의미를 부과하게 되는데 추후 변경이 어려우며 불일치가 발생할 수 있다.
* enum을 매핑되는 숫자 없이 사용한 경우, 목록의 중간에 별 생각없이 새로운 값을 지정하여 기존 데이터가 망가지는 사고가 발생할 수 있다.

'어떤 상태 이전'과 같은 조회를 할 때는 숫자가 편리함을 줄 수 있지만, 매번 추가/제거시 마이그레이션이 잘 된다는 전제가 필요하다.

[참고](https://stackoverflow.com/questions/14911977/best-way-to-store-enum-value-in-activerecord-and-convert-to-string-for-display) [참고](https://github.com/tpitale/constant_cache)

## count vs length vs size

- 만일 데이터가 필요하지 않다면, `.count`로 `count(*)` 쿼리를 날린다. 만일 counter cache가 사용중이라면, 해당 캐시의 값을 활용한다.
- `.length`는 데이터를 모두 메모리에 불러들인다. 만일 데이터를 이미 사용했거나 사용할 예정이라면 쓰면 되지만, 전체 맥락을 꿰고 있어야 하기 때문에 헷갈릴 수 있다.
- size는 위 두가지 중 추가 쿼리를 날리지 않는 방향을 선택해준다.

[참고](https://stackoverflow.com/questions/6083219/activerecord-size-vs-count)
