* 웹폰트 로딩에 import 보다는 link를 사용한다.
* 접근성 및 성능 측정에 [PageSpeed Insights](https://pagespeed.web.dev), Chrome Performance Insights를 사용한다.
    * 웹서버의 Gzip/Deflate 사용 여부를 확인한다.

## Importmaps와 HTTP/2

크롬의 경우, [HTTP 1에서는 TCP 연결이 6개로 제한된다.](https://stackoverflow.com/a/29564247) JS를 사용할 때 하나의 JS파일(예: application.js)로 패키징하는 대신 레일스 7에서부터 권장하기 시작한 [Import map](https://github.com/rails/importmap-rails)을 쓰면 큰 파일 하나 대신 작은 파일 여럿을 불러오는 구조가 되는데, 이때 HTTP 1을 쓴다면 앞의 크롬 특성과 맞물려 JS 파일 요청이 어셋과도 경합하면서 로딩이 매우 늦어지게 된다.

[관련 Puma 이슈](https://github.com/puma/puma/issues/2697)

이러한 HTTP/2로의 이행이 원활하지 않은 경우, 다음 방법들을 생각해볼수 있다.

* 가급적 jsdelivr 등의 CDN 라이브러리 활용
* [svgeez](https://github.com/jgarber623/svgeez)를 활용해 어셋을 HTML 내에 내장
* 이미지에 대한 [loading=lazy](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/img#loading) 설정
* StimulusJS 사용시 [lazy load 활용](https://github.com/hotwired/stimulus-rails#usage-with-import-map)

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

## 메시지·I18N
[은는이가](https://github.com/keepcosmos/ununiga) 젬을 사용하면 '은(는)' 처럼 조사를 결정해야 하는 경우 적절한 조사를 붙여준다.

## 메타태그 선언

파셜이 아닌 일반 페이지의 상단에서 선언한다. (참고: [Discourse](https://github.com/discourse/discourse/blob/ff38bccb8030011ea88060dcd84547d0822aad96/app/views/groups/show.html.erb#L1), [Gitlab](https://gitlab.com/gitlab-org/gitlab/blob/a1ad57aa1e2b4fecc92990d9aafa0f73ad0ff593/app/views/admin/abuse_reports/index.html.haml#L1)) 엄밀히는 뷰에 속하는 내용이므로 뷰단에서 선언하는 것이 자연스럽고, 컨트롤러나 모델에서 선언하는 것에 비해 백엔드 개발자가 아니라도 부담없이 작업할 수 있다. 파셜이 아닌 페이지에 기본으로 넣도록 원칙을 정하면 빼먹는 일이 없다. 모델에서 하는 것보다 유연하고, 의식적으로(혹은 데코레이터를 거쳐서) 뷰 단에서 사용할 내용만 쓰기 때문에, 모델에 선언하는 `as_json`처럼 실수로 보안 관련 내용을 노출시킬 염려가 상대적으로 적다.

설정은 [meta_tags](https://github.com/kpumuk/meta-tags#using-metatags-in-view) 젬을 쓰면 편하다.

## 컴퍼넌트

일반적으로 테일윈드에서 디자인 시스템의 컴퍼넌트를 반영할때는 역시 사용하는 프레임웍의 컴퍼넌트를 사용할 것을 권하지만, React처럼 클라이언트측 프레임워크가 아닌 ERB 템플릿 같은 경우 버튼 같은 작은 항목에 파셜을 만드는 것은 오버킬처럼 느껴질 수 있다. 이때는 `@apply`를 사용해 커스텀 CSS를 사용하고, 대신 보다 큰 단위에는 파셜을 쓴다. ([Reusing Styles](https://tailwindcss.com/docs/reusing-styles#extracting-classes-with-apply) 참고)

* [Performance Impact of Using Ruby on Rails View Partials](https://scoutapm.com/blog/performance-impact-of-using-ruby-on-rails-view-partials) - 파셜 사용 유무와 사용 방식에 따른 성능 차이를 볼 수 있다.

### 파셜로 컴퍼넌트 만들기의 팁

1. 현재 디자인 시스템에 존재하지 않는(혹은 UX 디자이너가 인지하지 못하는) CSS 컴퍼넌트에 의존해서 뭔가를 작성하면 안 된다. 오직 개발자만 알고 있는 내부의 리거시 컴퍼넌트에 의존해 무언가를 쌓는 일은 단순히 TailwindCSS의 설계철학에 반하는 것을 넘어서 코드에 고칠 수 없는 부분을 더하는 즉 기술부채를 더해나가는 일이다.
1. 여러 사이즈를 가진 파셜은 파셜 인자로 대응하지 않는다. 인자를 레일스에서 주면 스크린 너비에 따라 서로 다른 사이즈를 적용해야 하는 반응형에 대응하기 어렵고, 터보스트림 등으로 갱신되는 파셜의 경우 요청마다 인자를 계속 전파해야한다. 이를 놓치는 경우 버튼을 눌렀더니 커지거나 하는 문제가 생긴다.
1. 좋아요 버튼이 있다고 치자. "좋아요 하지 않았을 때(`unless liked?(something)`)"와 "로그인하지 않은 경우`unless user_signed_in?`"는 결과적으로 "현재 사용자가 좋아요하지 않은"으로 그 내용이 같으므로 같게 처리하면 된다. 로그인하지 않은 경우를 따로 분기해 로그인 페이지로 보내는 등의 처리를 할 필요가 없어야 한다. 비로그인 사용자가 로그인이 필요한 동작 요청시 로그인 페이지로 보내는 기능은 어차피 있어야 할 부분이다. 예를 들어 HTML에 노출되지 않더라도 API 레벨에서 직접 호출이 가능하고, 로그아웃 이후에도 사용자 브라우저에 남아있는 탭 등으로 얼마든지 발생할 수 있기 때문에 어차피 처리되어야만 한다.
1. 파셜이 어떤 때는 가로로 컨테이너를 채우고 어떤 때는 그렇지 않다고 할때, 테일윈드의 group이라던가 별도 인자로 처리하지 않도록 한다. flex/grid에는 이미 컨테이너가 아이템의 크기를 정할 수 있도록 하는 훌륭한 옵션들이 있다. 단, `link_to`가 아닌 `button_to`의 경우 실제 렌더링될때 `<form />`으로 감싸진다는 것을 감안, (테일윈드 기준) `w-full`을 넣어서 `<form />`의 너비에 의존하게 한다. 버튼을 `block`화 하는 것도 방법이지만, 보통은 `flex items-center` 등으로 정렬을 많이 할 것이라 `w-full`을 언급했다.
1. 위의 수정으로 별다른 클래스 추가 없이 자연스럽게 너비를 부모 컨테이너에 위임한다고 볼 때, 코드 전체를 감싸는 section/div 등 태그를 삽입하는 것은 좋은 습관이다.
  1. dom_id를 활용해 파셜 전체를 터보스트림으로 업데이트하는 것은 일반적인 패턴이다.
  1. group/button 같은 것을 넣어서 컴퍼넌트 내의 각 요소가 마우스 호버에 제각기 대응하도록 하기 좋다.
1. 파셜에 터보스트림을 적용하는 경우, 화면에 여러 번 표시되는 경우를 감안해 id와 class를 구분해서 쓰는 것이 좋다.

## 이용이 자유로운 템플릿

다음은 MIT 라이선스의 Tailwind 템플릿들.

* https://merakiui.com/
* https://www.tailwind-kit.com/templates#dashboard

그밖에 https://www.reddit.com/r/webdev/comments/pkx9k9/15_free_alternative_to_tailwind_ui_tailwind/ 에 다양한 다른 라이브러리들이 있다.

## 타겟 HTML 수준

참고 자료 : StatCounter의 [Android Market Share](https://gs.statcounter.com/android-version-market-share/all/south-korea), [iOS Market Share](https://gs.statcounter.com/os-version-market-share/ios/mobile-tablet/south-korea), Google Analytics의 브라우저 정보 등.

## Safe Area

모바일 페이지 개발시 상단이 아닌 하단에 붙는 버튼이나 메뉴 등을 고려하고 있다면 안전영역(Safe area)를 고려해야한다. [참고 설명](https://github.com/im-d-team/Dev-Docs/blob/master/CSS/safe-area.md)
예를 들자면 주소창이 기본으로 상단에 붙어 있고 하단에 홈 인디케이터(Home Indicator)가 표시되는 iOS용 크롬에서 홈 인디케이터와 버튼이 붙는 문제가 발생할 수 있다.
Tailwind를 사용하고 있다면 [tailwindcss-safe-area](https://github.com/mvllow/tailwindcss-safe-area) 플러그인을 사용하는 것으로 간단히 해결 가능하다.
