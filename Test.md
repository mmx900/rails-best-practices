## 통합 테스트

### 인터넷 연결

비록 테스트 환경을 개발환경이나 다른 환경과 구분해두었다고 하더라도, 의도치 않은 외부 웹 자원으로 연결될 수 있기에 차단해두는 것이 좋다.
[WebMock](https://github.com/bblimke/webmock)을 적용하면서 다음 메서드를 사용하면 로컬호스트 이외의 모든 연결을 차단할 수 있다.

```ruby
WebMock.disable_net_connect!(allow_localhost: true)
```

서비스에서 테스트 환경을 제공하는 경우 각 테스트에서 개별적으로 허용하면 된다.

### 요소 특정을 위한 라벨 vs 커스텀 속성

`click_on "내 버튼"` vs `find("[data-my-test]").click`

후자의 경우
* 오직 테스트를 위한 코드가 실제 코드에 들어간다.
* 실제 버튼에 사용된 라벨 대신 커스텀 속성을 사용함으로서 가독성이 떨어져, 불필요한 주석을 추가해야 해야 하기도 한다.
* click_on은 alt/title 을 지원함에도 커스텀 속성을 사용함으로써 적절한 대체 텍스트를 삽입할 기회를 놓치게 된다.
* 간혹 한 화면에 동일 이름의 버튼과 폼이 존재할 수도 있다(예: 로그인). 이 경우 click_button과 click_link를 구분해 사용하면 많은 경우 해결할 수 있다. rubocop의 경우 그래서 click_on 대신 click_button이나 click_link를 사용하도록 권장하는 cop도 존재한다.
* 실제 라벨이 사용된 테스트는 깨지기 쉽지만, 통합 테스트에서는 깨지기 쉬워도 사용자의 관점을 따라서 작성하는 테스트가 나쁘지 않다.

## trigger 보다 click 사용

Capybara의 trigger 설명을 보면, 사용자가 클릭할 수 있는지 여부와 관계없이 동작이 이뤄지는 트리거를 가능한 사용하지 않도록 지시하고 있다. flash 메시지등으로 인해 클릭이 되지 않는 문제는 실제 사용자가 경험하는 문제로, 이것을 trigger로 회피하는 것이 바람직하지 않다.

## 브라우저 테스트에는 Capybara의 메서드 우선 사용

브라우저를 띄워 동작시키는 테스트의 경우, 서버의 응답이 제때 이뤄지지 않는다거나 JS 처리가 느리다거나 하는 등으로 실패가 발생할 수 있다.
이때 Capybara의 대기 옵션을 사용하면 주어진 기간동안 대기한 후 다시 시도한다. (자세한 내용은 [Capybara README](https://github.com/teamcapybara/capybara/) 참고)

```ruby
Capybara.default_max_wait_time = 5
```

이때 주의할 점은 Capybara의 메서드에만 대기 기간이 적용된다는 것이다. 예컨대 `assert_selector`는 Capybaras의 메서드이므로 설정한 대기기간이 적용되지만, rails-dom-testing의 `assert_select`에는 적용되지 않는다.
