## Lint

* [Standard](https://github.com/standardrb/standard) 젬을 사용해 코딩 컨벤션을 통합할 수 있다. [IntelliJ 설정](https://www.jetbrains.com/help/idea/robocop.html#prerequisites).
  * standard 젬은 `--fix`와 `--fix-unsafely` 두 가지 자동 수정 옵션을 제공한다. 전자는 안전한 것으로 들여쓰기, 공백, 따옴표 치환 같은 것들로 바로 적용해도 무방하다. 후자는 로직 확인이 필요한 것으로 읽기를 위한 `self` 참조 제거, `and` 연산자를 `||`로 대체하는 동작 같은 것들이다.
  * 설정 후 `RuboCop Execution Error`가 뜨고 일반적인 방법으로 해결이 안 되는 경우, [여기에 제시된 방법](https://youtrack.jetbrains.com/issue/RUBY-27930/RuboCop-execution-error#focus=Comments-27-4798821.0-0)을 통해 직접 어떤 명령어가 IntelliJ 내부적으로 실행되는지 확인해보고 디버그할 수 있다.
* HTML 및 ERB 파일의 잠재적인 오류 : [erb-lint](https://github.com/Shopify/erb-lint), [better-html](https://github.com/Shopify/better-html)
    * better-html은 `<nav <% if user_signed_in? %>... >` 같은 문에서 `DontInterpolateHere` 오류가 발생한다. better-html의 [syntax-restriction](https://github.com/Shopify/better-html/blob/main/README.md#syntax-restriction) 참고.


## Security

다음 도구들을 사용해 코드의 보안성에 대한 정적 분석을 실행할 수 있다. 사용해보면 각각 확인하는 영역이 달라 둘 다 사용하길 추천.

* [Bearer](https://github.com/Bearer/bearer) ([Action](https://github.com/marketplace/actions/bearer-security))
* [Salus](https://github.com/coinbase/salus) ([Action](https://github.com/federacy/scan-action))
