## 설정 내용의 기록

민감한 키들은 레일스의 credential을 사용해 저장소에도 추가하되, 이를 복호화할 수 있는 키는 저장소에 추가하지 않는다. credential 파일의 특성상 브랜치별 충돌이 발생하면 확인과 병합이 까다로운데, [credman](https://github.com/Uscreen-video/credman)를 사용하면 이를 쉽게 해결해준다. (이를테면, conflict 발생 상태에서 두 내용이 모두 추가사항이면 병합해서 저장해준다.)
