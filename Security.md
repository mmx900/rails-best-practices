## 기본적인 준비

* 공식 가이드의 [Securing Rails Application](https://guides.rubyonrails.org/security.html)을 읽는다.
* 민감정보에 [Active Record Encryption](https://guides.rubyonrails.org/active_record_encryption.html)을 사용한다. 암호화를 적용하면 추가적으로 로그에서도 제외해준다.
* [Breakman](https://brakemanscanner.org/)과 [Salus](https://github.com/coinbase/salus)와 같은 도구들을 통해 소스코드를 검사한다. 둘 모두 깃헙 액션이 이미 있거나 간단하게 만들 수 있고, 오래된 의존성과 이름에 기반한 민감정보 암호화도 확인해준다.
* 깃헙인 경우 Dependabot과 같은 도구를 활성화해 보안 업데이트를 빠르게 적용한다. 다만 [asdf와 같은 일부 도구들이 제공되지 않아](https://github.com/dependabot/dependabot-core/issues/1033) 보다 넓은 지원을 위해서는 Renovate 같은 서드파티도 고려한다. `bin/importmap outdated`처럼 최신 도구의 경우에도 마찬가지다.
* 이용하는 젬을 줄인다. [XZ 백도어 사태](https://www.wired.com/story/jia-tan-xz-backdoor/)에서 보이듯 공급망 공격이 점점 흔해짐에 따라, Changelog만 믿고 라이브러리를 업데이트하는 일이 점점 안전하지 못한 일이 되고 있다.
* JS 또한 [Polyfill.io 사태](https://www.sonatype.com/blog/polyfill.io-supply-chain-attack-hits-100000-websites-all-you-need-to-know)에서 보이듯 다르지 않다. 불필요한 것은 사용하지 않고, 신뢰할 수 있는 저장소의 것을 사용하고, 가능하면 SRI를 적용한다. 참고로 importmap의 경우 SRI는 아직 일부 브라우저에서 실험적으로 구현중이며, importmap-rails 프로젝트에서는 이를 polyfill을 통해 지원하는 대신 로컬 설치를 권한다. [참고](https://github.com/rails/importmap-rails/issues/122)
* Sentry, NewRelic 등 외부 도구를 시스템과 연동할 시 민감정보를 제외하는 옵션을 찾는다.

## 설정 내용의 기록

민감한 키들은 레일스의 credential을 사용해 저장소에도 추가하되, 이를 복호화할 수 있는 키는 저장소에 추가하지 않는다. credential 파일의 특성상 브랜치별 충돌이 발생하면 확인과 병합이 까다로운데, [credman](https://github.com/Uscreen-video/credman)를 사용하면 이를 쉽게 해결해준다. (이를테면, conflict 발생 상태에서 두 내용이 모두 추가사항이면 병합해서 저장해준다.)
