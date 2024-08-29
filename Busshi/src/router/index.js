import { createRouter, createWebHistory } from 'vue-router';
import Victim from '@/components/Victim.vue';
import UserInput from '@/components/UserInput.vue';
import SignIn from '@/components/SignIn.vue';
import SelectRole from '@/components/SelectRole.vue';  
import SignupSuccess from '@/components/SignupSuccess.vue';  
import Suppoter from '@/components/Suppoter.vue';
import Mypage from '@/components/Mypage.vue';

const routes = [
  { path: '/', component: SelectRole }, 
  { path: '/products/search', component: Victim },
  { path: '/register', component: UserInput },
  { path: '/users/sign_in', component: SignIn },
  { path: '/register/success', component: SignupSuccess },
  { path: '/role2', component: Suppoter},
  { path: '/mypage', component: Mypage}
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
