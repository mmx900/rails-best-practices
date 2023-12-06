# rails-convention

여러 레일스 프로젝트에서 공통으로 사용할만한 룰이나 자료를 모읍니다.

## 참고 문서

* https://docs.publishing.service.gov.uk/manual/conventions-for-rails-applications.html

## 참고 프로젝트

### Rails 7

* https://github.com/forem/forem (StimulusJS, [AGPL 3.0](https://github.com/forem/forem/blob/main/LICENSE.md))
  * [개발 가이드](https://developers.forem.com/)
    * 특이사항 : [Service Object 패턴 사용](https://developers.forem.com/backend/service-objects)
* https://github.com/discourse/discourse (js, ember, [GPL 2.0](https://github.com/discourse/discourse/blob/main/LICENSE.txt))
* https://gitlab.com/gitlab-org/gitlab (js, vue, tiptap)
  * [개발 가이드](https://docs.gitlab.com/ee/development/contributing/index.html)
* https://github.com/mastodon/mastodon (js, react, [AGPL 3.0](https://github.com/mastodon/mastodon/blob/main/LICENSE))

### 그밖에

* https://github.com/asyraffff/Open-Source-Ruby-and-Rails-Apps
* https://github.com/gramantin/awesome-rails

### 가이드들

* https://world.hey.com/dhh/modern-web-apps-without-javascript-bundling-or-transpiling-a20f2755
* https://www.bearer.com/blog/how-to-build-modals-with-hotwire-turbo-frames-stimulusjs
* https://stackoverflow.com/questions/45295646/when-are-symbols-used-in-rails
* https://stackoverflow.com/questions/16621073/when-to-use-symbols-instead-of-strings-in-ruby

### 생각해 볼 주제들

* Naming
    * https://stackoverflow.com/questions/18495000/singular-or-plural-scope-names-in-rails
* Service Object Pattern
    * https://www.honeybadger.io/blog/refactor-ruby-rails-service-object/
    * https://intersect.whitefusion.io/the-art-of-code/why-service-objects-are-an-anti-pattern
* `# frozen_string_literal: true`
    * [Style/FrozenStringLiteralComment always on #181](https://github.com/standardrb/standard/pull/181)
    * [Ruby's Frozen String Comment: YAGNI](https://jakeworth.com/frozen-string-comment-yagni/)https://jakeworth.com/frozen-string-comment-yagni/
