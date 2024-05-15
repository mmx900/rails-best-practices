## 오래된 것들

오래된 프로젝트들을 유지보수할때 유용한 정보들을 제시한다.

### byebug와 debug

* [byebug](https://github.com/deivid-rodriguez/byebug)는 실행 중간에 `byebug` 문으로 실행을 중단할 수 있는 방법을 제시한다. 이제는 루비 3.1에 포함된 [debug](https://github.com/ruby/debug)https://github.com/ruby/debug 젬이 `binding.break`을 제공하므로, 더이상 필요하지 않다. [참고](https://dev.to/hmtanbir/-17ic)

### CarrierWave

* [CarrierWave](https://github.com/carrierwaveuploader/carrierwave)는 ActiveStorage가 도입되기 전 많이 사용되던 파일 첨부 및 이미지 첨부 솔루션이다. 최근들어 다시 꾸준히 개발되고 있긴 하지만, 만일 업그레이드를 원한다면 관련 문서가 많이 있다.
  * [From CarrierWave to to ActiveStorage](https://huy-hoang.medium.com/from-carrierwave-to-active-storage-b2fd3e71407f)

### rails-ujs

* rails-ujs가 나온 배경은 [6.x의 가이드 문서](https://guides.rubyonrails.org/v6.1.0/working_with_javascript_in_rails.html#unobtrusive-javascript)를 참고한다.
* rails-ujs에서 지원하던 기능들의 대안 기술들은 [7.x의 가이드 문서](https://guides.rubyonrails.org/working_with_javascript_in_rails.html#replacements-for-rails-ujs-functionality)를 참고한다.
* rails-ujs를 사용하던 기존 프로젝트를 어떻게 Turbo 기준으로 마이그레이션 할 것인가는 [관련 블로그 게시물](https://dev.to/thomasvanholder/how-to-migrate-rails-ujs-to-hotwire-turbo-hdh)을 참고한다.
* [7.1부터 import 구문이 바뀌었다](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#import-syntax-from-@rails-ujs-is-modified).
* rails-ujs는 [7.2에서 공식적으로 삭제될 예정이고](https://github.com/rails/rails/pull/50555), [이미 브랜치에서도 제거되었다](https://github.com/rails/rails/pull/50535).
  * 기존 README는 [삭제 직전 커밋](https://github.com/rails/rails/tree/66c174557a47865e95a5f8fecf54202d0dde92e7/actionview/app/javascript)에서 볼 수 있다.

### jQuery

* https://youmightnotneedjquery.com/ 에서는 jQuery를 일반적인 자바스크립트로 치환하기위한 예시들을 제시한다.
* [eslint-plugin-jquery](https://github.com/dgraham/eslint-plugin-jquery) 플러그인을 적용할 수 있다.
* [jQuery 업그레이드: 건강한 웹을 위한 노력](https://news.hada.io/topic?id=14400)은 jQuery를 최신 버전으로 유지해야 하는 이유를 설명한다.
