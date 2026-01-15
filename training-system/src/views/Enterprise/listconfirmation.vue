<template>
  <div class="generic-list-page">
    <div class="card-header">
      <h2>List Confirmation</h2>
    </div>

    <div class="filter-container" style="margin: 20px 0;">
      <el-input placeholder="Search Name" style="width: 200px; margin-right: 10px;" />
      <el-button type="primary">Search</el-button>
      <el-button type="primary" plain>Export List</el-button>
      <el-button type="success">Confirm All</el-button>
    </div>

    <el-table :data="tableData" border style="width: 100%">
      <el-table-column type="selection" width="55" />
      <el-table-column prop="name" label="Name" width="120" />
      <el-table-column prop="plan" label="Assigned Plan" width="200" />
      <el-table-column prop="status" label="Confirmation Status" width="150">
          <template #default="scope">
            <el-tag :type="scope.row.status === 'Confirmed' ? 'success' : 'warning'">{{ scope.row.status }}</el-tag>
          </template>
      </el-table-column>
      <el-table-column label="Actions">
        <template #default>
          <el-button size="small" type="primary">View Profile</el-button>
          <el-button size="small" type="success">Confirm</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-pagination layout="prev, pager, next" :total="30" style="margin-top: 20px; justify-content: flex-end" />
  </div>
</template>

<script setup>
import { ref } from 'vue'

const tableData = ref([
  { name: 'John Doe', plan: 'Spring Bootcamp 2024', status: 'Pending' },
  { name: 'Jane Smith', plan: 'Spring Bootcamp 2024', status: 'Confirmed' },
])
</script>
