<template>
  <div class="plan-audit">
    <div class="card-header">
      <h2>Plan Audit</h2>
    </div>

    <div class="filter-container" style="margin: 20px 0;">
      <el-select placeholder="Status" style="width: 150px; margin-right: 10px;">
        <el-option label="Pending" value="Pending" />
        <el-option label="Approved" value="Approved" />
        <el-option label="Rejected" value="Rejected" />
      </el-select>
      <el-button type="primary">Filter</el-button>
    </div>

    <el-table :data="tableData" border style="width: 100%">
      <el-table-column prop="enterprise" label="Enterprise" />
      <el-table-column prop="planName" label="Plan Name" />
      <el-table-column prop="submittedDate" label="Submitted Date" />
      <el-table-column prop="status" label="Status">
         <template #default="scope">
            <el-tag :type="scope.row.status === 'Pending' ? 'warning' : 'success'">{{ scope.row.status }}</el-tag>
          </template>
      </el-table-column>
      <el-table-column label="Actions">
        <template #default="scope">
          <el-button size="small" type="primary" @click="handleAudit(scope.row)">Audit</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog v-model="dialogVisible" title="Audit Plan" width="30%">
      <span>Approve this plan?</span>
      <template #footer>
        <el-button @click="dialogVisible = false">Cancel</el-button>
        <el-button type="danger" @click="confirmAudit('Rejected')">Reject</el-button>
        <el-button type="success" @click="confirmAudit('Approved')">Approve</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'

const dialogVisible = ref(false)
const currentPlan = ref(null)

const tableData = ref([
  { id: 101, enterprise: 'Tech Giant Corp', planName: 'Java 全栈开发特训营', submittedDate: '2024-01-15', status: 'Approved' },
  { id: 102, enterprise: 'Tech Giant Corp', planName: '产品经理精英训练营', submittedDate: '2024-02-01', status: 'Approved' },
  { id: 103, enterprise: 'Future AI Inc', planName: '数据科学入门班', submittedDate: '2024-03-01', status: 'Pending' },
])

const handleAudit = (row) => {
  currentPlan.value = row
  dialogVisible.value = true
}

const confirmAudit = (status) => {
  if (currentPlan.value) {
    currentPlan.value.status = status
  }
  dialogVisible.value = false
  ElMessage.success(`Plan ${status}`)
}
</script>
