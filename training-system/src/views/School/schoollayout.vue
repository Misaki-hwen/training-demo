<template>
  <div class="school-layout">
    <el-card>
      <el-tabs v-model="activeTab">
        <el-tab-pane label="Training Management" name="training">
          <TrainingManagement v-if="activeTab === 'training'" />
        </el-tab-pane>
        <el-tab-pane label="Attendance Management" name="attendance">
          <AttendanceManagement v-if="activeTab === 'attendance'" />
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import TrainingManagement from './TrainingManagement.vue'
import AttendanceManagement from './AttendanceManagement.vue'

const activeTab = ref('training')
</script>
