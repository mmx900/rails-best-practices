## Scope 혹은 Where

`ActiveRecord::Relation#where`는 다음 두 가지 방식으로 쓸 수 있다.

```ruby
User.where(name: name)
User.where("name: ?", name)

# 좀 더 복잡하게
User.where(name: name).or(User.where(email: email))
User.where("name = ? OR email = ?", name, email)
```

둘 모두 parameterize 되는 안정적인 코드이고, 구문이 복잡해지는 경우 후자가 더 깔끔하게 보이지만, 전자를 선호하는 이유는 동일 컬럼을 가지고 있는 join이 일어나는 상황에서 `PG::AmbiguousColumn` 같은 오류를 막아주기 때문이다. 대부분의 인라인 상황에서는 별 차이가 없겠지만 어떤 쿼리가 이어질 지 모르는 scope를 구현하는 경우 특히 유용하다.

```ruby
  scope :with_friend, ->(value) {
    self_join = -> { joins("left join users friends on user.friend_id = friends.id") }
    # ...
  }
  scope :name, ->(name) {
    where("name = ?", name) # with_friend와 함께 사용시 AmbiguousColumn 에러!
  }
```

부가적으로, 전자의 구문은 인자가 배열인 경우에도 코드를 수정할 필요 없이 알아서 잘 처리해준다. 보통은 단일 값이 들어올지 복수 값이 들어올지 명확하므로, 이 또한 scope 구현시 특히 유용하다.

```ruby
value = "abc"
User.where(name: value) # where name = 'abc'

value = ["abc", "def"]
User.where(name: value) # where name in ('abc', 'def')
```
