```ruby
class UsersController < ApplicationController
```

index, new, create를 제외하고는 멤버에 대한 작업으로 간주되기 때문에 다음 코드가 주로 쓰인다. [참고1](https://gitlab.com/gitlab-org/gitlab/blob/b8b0bbea7275ac3fe220c67cd563673ce1570461/app/controllers/admin/users_controller.rb#L7) [참고2](https://github.com/mastodon/mastodon/blob/af49d93fd6168c089530240a9ab4eccb975b8c42/app/controllers/admin/roles_controller.rb#L5)

```ruby
  before_action :set_user, except: [:index, :new, :create]
```

`set_user` 에서는 `@user`를 설정한다. 예외 처리는 경우에 따라 다른데, 특별한 이유가 없다면 처리를 하지 않음으로써 RecordNotFound 오류를 통해 자연스럽게 404 오류와 관련 페이지가 표시되게끔 한다.

```ruby
  private

  def set_user
    @user = User.find(params[:id])
  end
```

```ruby
end
```
