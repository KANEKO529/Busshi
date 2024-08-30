import { createRouter, createWebHistory } from 'vue-router';

import SignIn from '@/components/SignIn.vue';
import SignupSuccess from '@/components/SignupSuccess.vue';
import SignUp from '@/components/SignUp.vue';
import Home from '@/components/Home.vue';
import Ranking from '@/components/Ranking.vue';
import Search from '@/components/Search.vue';
import Navigation from '@/components/Navigation.vue';

const routes = [
  { path: '/', component: Home },
  { path: '/signup', component: SignUp },
  { path: '/signin', component: SignIn },
  { path: '/signup/success', component: SignupSuccess },
  // { path: '/search', component: Search}
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
