<template>
  <div class="generic-list-page">
    <div class="card-header">
      <h2>Student Screening</h2>
    </div>

    <div class="filter-container" style="margin: 20px 0;">
      <el-input placeholder="Search Student" style="width: 200px; margin-right: 10px;" />
      <el-select placeholder="University" style="width: 150px; margin-right: 10px;">
        <el-option label="Univ A" value="A" />
        <el-option label="Univ B" value="B" />
      </el-select>
      <el-button type="primary">Filter</el-button>
      <el-button type="success">Batch Pass</el-button>
      <el-button type="danger">Batch Reject</el-button>
    </div>

    <el-table :data="tableData" border style="width: 100%" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" />
      <el-table-column prop="name" label="Name" width="120" />
      <el-table-column prop="university" label="University" width="200" />
      <el-table-column prop="major" label="Major" width="150" />
      <el-table-column prop="gpa" label="GPA" width="80" />
      <el-table-column prop="status" label="Status" width="100">
          <template #default="scope">
            <el-tag>{{ scope.row.status }}</el-tag>
          </template>
      </el-table-column>
      <el-table-column label="Actions">
        <template #default>
          <el-button size="small" type="primary">Detail</el-button>
          <el-button size="small" type="success">Pass</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-pagination layout="prev, pager, next" :total="50" style="margin-top: 20px; justify-content: flex-end" />
  </div>
</template>

<script setup>
import { ref } from 'vue'

const tableData = ref([
  { name: 'John Doe', university: 'Tech Univ', major: 'CS', gpa: '3.8', status: 'Pending' },
  { name: 'Jane Smith', university: 'State Univ', major: 'Math', gpa: '3.9', status: 'Pending' },
  { name: 'Bob Johnson', university: 'Tech Univ', major: 'EE', gpa: '3.5', status: 'Screening' },
])

const handleSelectionChange = (val) => {
  console.log(val)
}
</script>
