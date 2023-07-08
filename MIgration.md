마이그레이션 실행시, `unknown attribute '컬럼명' for 모델명` 식의 예외가 발생하는 경우가 있다. 주로 테이블 생성이나 컬럼 추가 직후 추가된 대상에 어떤 작업을 하는 경우인데, 한 마이그레이션 파일 안에서 뿐 아니라 여러 마이그레이션이 연속적으로 실행되는 경우(db:prepare 실행이나 한번에 서버에 배포하는 경우)에도 발생할 수 있다. 로컬 개발환경에서는 잘 재현이 안되는데, 이때 [reset_column_information](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema/ClassMethods.html#method-i-reset_column_information)을 넣어두면 안전하다.

```ruby
User.reset_column_information # 대상 모델명이 User인 경우
```

PostgreSQL 등 시퀀스를 ID로 사용하는 DB이면서, ID를 여러 이유로 마이그레이션(혹은 DB 작업)에서 직접 지정하게 되면, ID의 기본값인 nextval()이 호출되지 않아 충돌이 발생하게 된다. 이때는 reset_pk_sequence!를 이어서 넣어준다. [참고](https://www.rubyinrails.com/2019/07/12/postgres-reset-sequence-to-max-id-in-rails/)

```ruby
User.create id: 1, name: "User One"
User.create id: 2, name: "User Two"
ActiveRecord::Base.connection.reset_pk_sequence!("users")
```
