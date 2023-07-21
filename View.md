* 웹폰트 로딩에 import 보다는 link를 사용한다.
* 접근성 및 성능 측정에 [PageSpeed Insights](https://pagespeed.web.dev), Chrome Performance Insights를 사용한다.
    * 웹서버의 Gzip/Deflate 사용 여부를 확인한다.

## content_tag 대신 tag 쓰기

과거에는 [content_tag만 블럭을 인자로 줄 수 있었지만](https://stackoverflow.com/questions/20363506/rails-content-tag-vs-tag), 2023년 현재는 tag 역시 가능하기에 content_tag가 아닌 tag만 사용하면 된다. [API 문서](https://api.rubyonrails.org/classes/ActionView/Helpers/TagHelper.html#method-i-tag)에도 content_tag를 'legacy syntax'로 안내하고 있다.

## HAML 대신 ERB 쓰기

HAML이 간결하지만, ERB는 다음 강점이 있다.

* 익숙해지기 쉬움 : HAML이 기본적인 내용은 익히기 쉽지만 데이터 속성에 루비 변수를 바인딩하는 등의 작업에 들어가면 익숙해지는 시간이 필요하다. 대신 결과물은 깔끔하다. ERB는 애초에 PHP 등 다른 언어나 웹 프레임워크를 다뤄봤다면 익숙해질 내용이 거의 없다.
* 웹에서 코드 스니펫을 적용시 (구글 애널리틱스 적용 코드부터 스택 오버플로우에서 가져온 코드에 이르기까지) 반드시 번역이 필요하다.
* 테일윈드 사용시, 브라우저 개발자 도구에서 읽은 요소의 클래스명을 지문처럼 사용해 코드를 검색할 수 있는데 HAML은 이렇게 바로 쓸 수 없다.
* 테일윈드 사용시, `w-1/2` 같은 클래스명 중간에 기호가 들어간 항목은 인식이 안 되서 `class`로 별도 지정해야 한다.
* 코드 수정시 사소한 들여쓰기 실수로 심각한 문제를 유발할 수 있다.

### HAML2ERB 변환

사이트로는 https://haml2erb.org/, 라이브러리는 https://github.com/danchoi/herbalizer 가 있으며 다음 한계들을 공유하는 것으로 보아 같은 라이브러리로 동작하는 것으로 보인다.

* 비 ASCII 문자 지원 불가
* `~` 처리 안됨
* (주로 테일윈드에서 쓰이는) `md:t-1` 같은 콜론이 들어간 CSS 클래스명 해석 불가

## 이용이 자유로운 템플릿

다음은 MIT 라이선스의 Tailwind 템플릿들.

* https://merakiui.com/
* https://www.tailwind-kit.com/templates#dashboard

그밖에 https://www.reddit.com/r/webdev/comments/pkx9k9/15_free_alternative_to_tailwind_ui_tailwind/ 에 다양한 다른 라이브러리들이 있다.
