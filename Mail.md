## [params vs arguments](https://stackoverflow.com/a/77664080/1565245)

ActionMailer를 통해 메일을 보낼 때 보통 `SomeMailer.with(user).invitation.deliver_later` 같은 식으로 작성하는데, 왜 `invitation(user)` 같은 식으로는 작성하지 않는지 [가이드 문서](https://guides.rubyonrails.org/v7.1.2/action_mailer_basics.html)에는 나와있지 않다. 이 이유는 [ActionMailer::Parameterized API 문서](https://api.rubyonrails.org/classes/ActionMailer/Parameterized.html)에 좋은 예시와 함께 나와있는데, 요약하면 여러 메서드들의 공통 인자와 전처리 등을 하기 적합하다. 바꿔 말하면, 예컨대 1개의 메일러에 1개의 액션만 있는 상황이라고 한다면 반드시 `with`문을 써서 파라미터로 구현할 필요는 없다.

## 생각해볼 거리

어떤 작업이 끝난 경우 메일을 발송하는 것이 일반적이다. 이때 메일은 어디서 보내는 것이 좋을까? 1) 컨트롤러에서 변경 명령 다음에. 2) 모델에서 변경사항이 이뤄진 후.

참고
https://stackoverflow.com/questions/3852523/rails-is-it-better-to-send-email-notifications-from-a-model-or-a-controller
