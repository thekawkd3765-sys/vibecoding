# Supabase 설정

1. Supabase Dashboard에서 프로젝트를 만든다.
2. `Authentication > Sign In / Providers`에서 `Email` provider를 켠다. 이 앱은 이메일/비밀번호 회원가입과 로그인을 사용하므로 Anonymous sign-ins는 필요 없다.
3. 이메일 확인을 사용할 경우 `Authentication > URL Configuration`에서 Site URL과 Redirect URLs에 로컬/배포 주소를 등록한다.
4. `SQL Editor`에서 `supabase/schema.sql`을 실행한다. `habits` 테이블은 `auth.users`의 사용자 ID를 저장하고, RLS 정책으로 로그인한 사용자가 자기 습관만 읽고 수정하게 제한한다.
5. `Project Settings > API`에서 Project URL과 publishable key를 복사한다. `secret`, `service_role`, `sb_secret_...` 키는 브라우저 환경 변수에 넣지 않는다.
6. `.env.local`에 아래 값을 넣는다.

```env
VITE_SUPABASE_URL=https://YOUR-PROJECT-REF.supabase.co
VITE_SUPABASE_PUBLISHABLE_KEY=sb_publishable_REPLACE_ME
```

7. 로컬 실행은 아래 순서로 한다. 이 앱은 Vite가 `import.meta.env`와 npm 패키지 import를 처리해야 하므로 Live Server로 직접 열지 않는다.

```bash
npm install
npm run dev
```

8. Vercel 등에 배포한다면 같은 환경 변수를 배포 프로젝트에도 추가한다. `.env.local`은 `.gitignore` 대상이라 저장소에 올라가지 않는다.