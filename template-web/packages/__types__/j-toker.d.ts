declare module 'j-toker' {
  const configured: boolean;
  const validateToken: promiseFunction;
  const configure: voidFunction;
  const emailSignUp: promiseFunction;
  const oAuthSignIn: promiseFunction;
  const signOut: promiseFunction;
  const retrieveData: anyFunction;
  const persistData: anyFunction;
  const buildAuthHeaders: anyFunction;
  const emailSignIn: anyFunction;
  const requestPasswordReset: promiseFunction;
  const updatePassword: promiseFunction;
}
