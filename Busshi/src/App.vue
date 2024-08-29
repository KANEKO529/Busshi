<template>
  <div id="app">
    <Navigation v-if="$route.meta.showNavigation" />
    <router-view />

    <!-- <ApiTest /> -->
    <!-- <Victim /> -->
    <!-- <UserInput /> -->
  </div>
</template>

<script>
import ApiTest from './components/ApiTest.vue';
import Victim from './components/Victim.vue';
import UserInput from './components/UserInput.vue';
import SignIn from './components/SignIn.vue';
import SelectRole from './components/SelectRole.vue'; // 追加
import SignupSuccess from './components/SignupSuccess.vue';  // 追加
import Navigation from './components/Navigation.vue';

export default {

  name: 'App',
  components: {
    ApiTest,
    Victim,
    UserInput,
    SignIn,
    SelectRole, // 追加
    SignupSuccess, // 追加
    Navigation
  }
}
</script>
