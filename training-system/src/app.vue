<template>
  <div class="app-container">
    <el-container>
      <el-header height="60px">
        <div class="logo">Training Management System</div>
        <el-menu
          :default-active="activePath"
          mode="horizontal"
          router
          background-color="#fff"
          text-color="#303133"
          active-text-color="#409EFF"
        >
          <el-menu-item index="/enterprise">Enterprise</el-menu-item>
          <el-menu-item index="/operation">Operation</el-menu-item>
          <el-menu-item index="/school">School</el-menu-item>
          <el-menu-item index="/student">Student</el-menu-item>
        </el-menu>
        <div class="user-info">
          <el-avatar :size="32" icon="UserFilled" />
          <span style="margin-left: 10px; font-size: 14px;">Admin</span>
        </div>
      </el-header>

      <el-main>
        <router-view />
      </el-main>
    </el-container>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const activePath = computed(() => `/${route.path.split('/')[1]}`)
</script>

<style scoped>
.app-container {
  height: 100vh;
  display: flex;
  flex-direction: column;
}
.el-main {
  background-color: #f5f7fa;
  padding: 20px;
}
</style>
