플랫폼을 특별히 지정해두지 않는다면, nokogiri나 google-protobuf 같은 네이티브 지원이 이루어지는 젬을 설치하면서 Gemfile.lock이 특정 플랫폼(아마도 개발자 환경) 전용으로 고정될 수 있다. Gemfile.lock의 platform 항목이나 다음 명령을 통해 조회 가능하다.

```shell
~/g/my-rails ❯❯❯ bundle platform
Your platform is: x86_64-darwin-22

Your app has gems that work on these platforms:
* x86_64-darwin-22
* x86_64-linux
```

ruby라고 나온다면 관계없지만 그렇지 않고 특정 환경으로 고정되어 있다면 다음 명령을 통해 추가 가능하다. [참고](https://bundler.io/v2.4/man/bundle-lock.1.html)

```shell
bundle lock --add-platform arm64-darwin-22 # m1 노트북의 경우
```
