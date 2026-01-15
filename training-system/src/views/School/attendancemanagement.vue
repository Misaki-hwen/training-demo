<template>
  <div class="attendance-management">
    <div class="card-header">
      <h2>Attendance Management</h2>
    </div>

    <el-table :data="tableData" border style="width: 100%; margin-top: 20px;">
      <el-table-column prop="student" label="Student" />
      <el-table-column prop="date" label="Date" />
      <el-table-column prop="status" label="Status">
        <template #default="scope">
           <el-tag :type="scope.row.status === 'Present' ? 'success' : 'danger'">{{ scope.row.status }}</el-tag>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const tableData = ref([
  { student: 'John Doe', date: '2024-03-01', status: 'Present' },
  { student: 'John Doe', date: '2024-03-02', status: 'Absent' },
])
</script>
