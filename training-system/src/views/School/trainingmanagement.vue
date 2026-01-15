<template>
  <div class="training-management">
    <div class="card-header">
      <h2>Training Management</h2>
    </div>
    
    <el-table :data="tableData" border style="width: 100%; margin-top: 20px;">
      <el-table-column prop="student" label="Student Name" />
      <el-table-column prop="plan" label="Training Plan" />
      <el-table-column prop="company" label="Company" />
      <el-table-column prop="status" label="Status" />
    </el-table>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const tableData = ref([
  { student: 'John Doe', plan: 'Java 全栈开发特训营', company: 'Tech Giant Corp', status: 'In Progress' },
  { student: 'Jane Smith', plan: '产品经理精英训练营', company: 'Tech Giant Corp', status: 'Pending' },
])
</script>
