<template>
  <div class="settlement-management">
    <div class="card-header">
      <h2>Settlement Management</h2>
    </div>

    <el-table :data="tableData" border style="width: 100%; margin-top: 20px;">
      <el-table-column prop="enterprise" label="Enterprise" />
      <el-table-column prop="plan" label="Plan" />
      <el-table-column prop="amount" label="Amount" />
      <el-table-column prop="status" label="Status">
         <template #default="scope">
            <el-tag :type="scope.row.status === 'Paid' ? 'success' : 'danger'">{{ scope.row.status }}</el-tag>
          </template>
      </el-table-column>
      <el-table-column label="Actions">
        <template #default="scope">
          <el-button size="small" type="primary" v-if="scope.row.status !== 'Paid'">Mark as Paid</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const tableData = ref([
  { enterprise: 'Tech Corp', plan: 'Java Training', amount: '$5000', status: 'Unpaid' },
  { enterprise: 'Soft Inc', plan: 'Frontend Bootcamp', amount: '$4500', status: 'Paid' },
])
</script>
