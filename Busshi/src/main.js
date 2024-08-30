import './assets/main.css'
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'  // Vuex ストアのインポート
// import './assets/theme.css'; // テーマの変更に対応させるため（必要ない場合はコメントアウト）

const app = createApp(App);  // アプリケーションインスタンスを作成
app.use(store);              // Vuex ストアをアプリケーションに登録
app.use(router);             // Vue Router をアプリケーションに登録
app.mount('#app');           // アプリケーションをマウント
