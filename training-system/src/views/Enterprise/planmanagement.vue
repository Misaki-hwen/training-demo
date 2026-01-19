<template>
  <div class="plan-management">
    <div class="card-header">
      <h3>计划管理</h3>
      <el-button type="primary" @click="handleCreate">创建计划</el-button>
    </div>
    <div class="filter-container">
      <el-input v-model="searchQuery" placeholder="搜索计划名称" style="width: 200px; margin-right: 10px;"></el-input>
      <el-select v-model="filterStatus" placeholder="状态" clearable style="width: 120px; margin-right: 10px;">
        <el-option label="草稿" value="Draft"></el-option>
        <el-option label="待审核" value="Pending"></el-option>
        <el-option label="审核中" value="Auditing"></el-option>
        <el-option label="已通过" value="Approved"></el-option>
        <el-option label="已驳回" value="Rejected"></el-option>
      </el-select>
      <el-button type="primary" icon="Search" @click="handleSearch">搜索</el-button>
    </div>
    <el-table :data="tableData" style="width: 100%" border v-loading="loading">
      <el-table-column type="index" label="序号" width="60"></el-table-column>
      <el-table-column label="计划名称" min-width="150">
        <template #default="scope">
          <span style="color: #409EFF; cursor: pointer; text-decoration: underline;" @click="handleDetail(scope.row)">{{ scope.row.planName }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="positionType" label="岗位类型" width="120"></el-table-column>
      <el-table-column prop="headcount" label="需求人数" width="100"></el-table-column>
      <el-table-column prop="status" label="状态" width="100">
        <template #default="scope">
          <el-tag :type="getStatusType(scope.row.status)">{{ getStatusLabel(scope.row.status) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="submitTime" label="提交时间" width="160"></el-table-column>
      <el-table-column label="操作" width="280" fixed="right">
        <template #default="scope">
          <el-button size="small" type="primary" v-if="['Draft', 'Rejected'].includes(scope.row.status)" @click="handleEdit(scope.row)">编辑</el-button>
          <el-button size="small" type="success" v-if="['Draft', 'Rejected'].includes(scope.row.status)" @click="handleSubmit(scope.row)">提交审核</el-button>
          <el-button size="small" type="danger" v-if="['Draft', 'Rejected'].includes(scope.row.status)" @click="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- Create/Edit Dialog -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="65%" top="5vh">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="120px" :disabled="isViewMode">
        <div class="section-title">基本信息</div>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="计划名称" prop="planName">
              <el-input v-model="form.planName" maxlength="50" show-word-limit placeholder="50字以内"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="岗位类型" prop="positionType">
              <el-select v-model="form.positionType" style="width: 100%">
                <el-option v-for="type in positionTypes" :key="type" :label="type" :value="type"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="需求人数" prop="headcount">
              <el-input-number v-model="form.headcount" :min="1" :max="500" style="width: 100%"></el-input-number>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="培训周期" prop="dateRange">
              <el-date-picker v-model="form.dateRange" type="daterange" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="YYYY-MM-DD" style="width: 100%"></el-date-picker>
            </el-form-item>
          </el-col>
        </el-row>
        
        <div class="section-title">培训地点</div>
        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="省份" prop="province">
              <el-select v-model="form.province" placeholder="请选择省份" @change="form.city = ''" style="width: 100%">
                <el-option v-for="p in provinceList" :key="p.value" :label="p.label" :value="p.value"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="城市" prop="city">
              <el-select v-model="form.city" placeholder="请选择城市" style="width: 100%">
                <el-option v-for="c in getCityList(form.province)" :key="c.value" :label="c.label" :value="c.value"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="详细地址" prop="address">
              <el-input v-model="form.address" placeholder="请输入详细地址"></el-input>
            </el-form-item>
          </el-col>
        </el-row>

        <div class="section-title">预算费用</div>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="培训费用(元)" prop="budgetFee">
              <el-input-number v-model="form.budgetFee" :min="0" :precision="2" style="width: 100%"></el-input-number>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="结算方式" prop="settlementMethod">
              <el-radio-group v-model="form.settlementMethod">
                <el-radio label="Post">培训后结算</el-radio>
                <el-radio label="Phased">分阶段结算</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="预算说明" prop="budgetDesc">
            <el-input v-model="form.budgetDesc" type="textarea" :rows="2" placeholder="请输入费用构成说明"></el-input>
        </el-form-item>

        <div class="section-title">要求信息</div>
        <el-form-item label="学历要求" prop="education">
          <el-checkbox-group v-model="form.education">
            <el-checkbox label="大专">大专</el-checkbox>
            <el-checkbox label="本科">本科</el-checkbox>
            <el-checkbox label="硕士">硕士</el-checkbox>
            <el-checkbox label="博士">博士</el-checkbox>
          </el-checkbox-group>
        </el-form-item>
        <el-form-item label="专业要求" prop="major">
          <el-input v-model="form.major" placeholder="可输入多个专业，用逗号分隔"></el-input>
        </el-form-item>
        <el-form-item label="技能要求" prop="skills">
          <el-input v-model="form.skills" type="textarea" :rows="2" placeholder="可输入多个技能，用逗号分隔"></el-input>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" maxlength="500" show-word-limit></el-input>
        </el-form-item>
        
        <div v-if="form.status === 'Rejected'" style="margin-top: 20px; padding: 10px; background-color: #fef0f0; border-radius: 4px;">
          <div style="color: #f56c6c; font-weight: bold; margin-bottom: 5px;">驳回信息</div>
          <p style="margin: 0; color: #606266;">驳回原因: {{ form.auditComment }}</p>
          <p style="margin: 5px 0 0; color: #909399; font-size: 12px;">审核时间: {{ form.auditTime }}</p>
        </div>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">{{ isViewMode ? '关闭' : '取消' }}</el-button>
          <el-button type="primary" @click="submitForm" v-if="!isViewMode">保存</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'

const loading = ref(false)
const searchQuery = ref('')
const filterStatus = ref('')
const dialogVisible = ref(false)
const dialogTitle = ref('创建计划')
const isViewMode = ref(false)
const formRef = ref(null)

const positionTypes = ['技术类', '管理类', '营销类', '生产类', '服务类']
const provinceList = [
  { value: 'Beijing', label: '北京' },
  { value: 'Shanghai', label: '上海' },
  { value: 'Guangdong', label: '广东' }
]
const cityMap = {
  'Beijing': [{ value: 'Beijing', label: '北京市' }],
  'Shanghai': [{ value: 'Shanghai', label: '上海市' }],
  'Guangdong': [{ value: 'Guangzhou', label: '广州市' }, { value: 'Shenzhen', label: '深圳市' }]
}
const getCityList = (province) => cityMap[province] || []

const tableData = ref([])

const API_BASE = import.meta.env.VITE_API_BASE || 'http://localhost:8000'

const form = reactive({ 
  id: null, planName: '', positionType: '', headcount: 0, 
  dateRange: [], province: '', city: '', address: '',
  education: [], major: '', skills: '', 
  budgetFee: 0, settlementMethod: 'Post', budgetDesc: '',
  remark: '', status: 'Draft', auditComment: '', auditTime: '', submitTime: ''
})

const rules = {
  planName: [{ required: true, message: '必填', trigger: 'blur' }],
  positionType: [{ required: true, message: '必选', trigger: 'change' }],
  headcount: [{ required: true, message: '必填', trigger: 'blur' }],
  dateRange: [{ required: true, message: '必填', trigger: 'change' }],
  province: [{ required: true, message: '必选', trigger: 'change' }],
  city: [{ required: true, message: '必选', trigger: 'change' }],
  address: [{ required: true, message: '必填', trigger: 'blur' }],
  education: [{ required: true, message: '至少选一项', trigger: 'change' }],
  budgetFee: [{ required: true, message: '必填', trigger: 'blur' }],
  settlementMethod: [{ required: true, message: '必选', trigger: 'change' }]
}

const getStatusLabel = (status) => {
  const map = { 'Draft': '草稿', 'Pending': '待审核', 'Auditing': '审核中', 'Approved': '已通过', 'Rejected': '已驳回', 'Published': '已发布' }
  return map[status] || status
}
const getStatusType = (status) => {
  const map = { 'Draft': 'info', 'Pending': 'warning', 'Auditing': 'primary', 'Approved': 'success', 'Rejected': 'danger', 'Published': 'success' }
  return map[status] || ''
}

const resetForm = () => {
  Object.assign(form, { 
    id: null, planName: '', positionType: '', headcount: 0, 
    dateRange: [], province: '', city: '', address: '',
    education: [], major: '', skills: '', 
    budgetFee: 0, settlementMethod: 'Post', budgetDesc: '',
    remark: '', status: 'Draft', auditComment: '', auditTime: '', submitTime: ''
  })
}

const handleCreate = () => { 
  dialogTitle.value = '创建计划'
  isViewMode.value = false
  resetForm()
  dialogVisible.value = true 
}

const handleEdit = (row) => { 
  dialogTitle.value = '编辑计划'
  isViewMode.value = false
  Object.assign(form, row) 
  form.dateRange = [row.startDate, row.endDate]
  dialogVisible.value = true 
}

const handleDetail = (row) => {
  dialogTitle.value = '计划详情'
  isViewMode.value = true
  Object.assign(form, row)
  form.dateRange = [row.startDate, row.endDate]
  dialogVisible.value = true
}

const handleSubmit = (row) => {
  ElMessageBox.confirm('确定提交审核吗?', '提示').then(() => {
    row.status = 'Pending'
    row.submitTime = new Date().toISOString().split('T')[0]
    ElMessage.success('已提交审核')
  })
}

const submitForm = async () => {
  if (!formRef.value) return
  await formRef.value.validate(async (valid) => {
    if (valid) {
      const payload = {
        enterprise_id: 1,
        name: form.planName,
        position_type: form.positionType,
        headcount: form.headcount,
        budget: form.budgetFee,
        education_requirements: form.education.join(','),
        major_requirements: form.major,
        skills_requirements: form.skills,
        start_date: form.dateRange[0] || null,
        end_date: form.dateRange[1] || null,
        location: form.city || form.province || '',
        settlement_method: form.settlementMethod,
        remark: form.remark
      }
      loading.value = true
      try {
        const url = form.id ? `${API_BASE}/api/plans/${form.id}` : `${API_BASE}/api/plans/`
        const method = form.id ? 'PUT' : 'POST'
        const res = await fetch(url, {
          method,
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(payload)
        })
        if (!res.ok) {
          throw new Error('接口调用失败')
        }
        const data = await res.json()
        const mapped = {
          id: data.id,
          planName: data.name,
          positionType: data.position_type,
          headcount: data.headcount,
          startDate: data.start_date,
          endDate: data.end_date,
          province: form.province,
          city: form.city,
          address: form.address,
          education: form.education.slice(),
          major: form.major,
          skills: form.skills,
          budgetFee: form.budgetFee,
          settlementMethod: form.settlementMethod,
          budgetDesc: form.budgetDesc,
          remark: form.remark,
          status: data.status,
          auditComment: form.auditComment,
          auditTime: form.auditTime,
          submitTime: form.submitTime
        }
        if (form.id) {
          const idx = tableData.value.findIndex(item => item.id === form.id)
          if (idx !== -1) tableData.value[idx] = mapped
        } else {
          tableData.value.push(mapped)
          form.id = data.id
        }
        dialogVisible.value = false
        ElMessage.success('保存成功')
      } catch (e) {
        ElMessage.error('保存失败，请检查后端服务')
      } finally {
        loading.value = false
      }
    }
  })
}

const handleDelete = (row) => {
  ElMessageBox.confirm('确定删除该计划吗?', '提示', { type: 'warning' }).then(() => {
    tableData.value = tableData.value.filter(item => item.id !== row.id)
    ElMessage.success('已删除')
  })
}
const handleSearch = () => ElMessage.success('搜索已执行')

onMounted(async () => {
  loading.value = true
  try {
    const res = await fetch(`${API_BASE}/api/plans/`)
    if (!res.ok) throw new Error('接口调用失败')
    const list = await res.json()
    tableData.value = list.map(item => ({
      id: item.id,
      planName: item.name,
      positionType: item.position_type,
      headcount: item.headcount,
      startDate: item.start_date,
      endDate: item.end_date,
      province: '',
      city: item.location,
      address: '',
      education: item.education_requirements ? item.education_requirements.split(',') : [],
      major: item.major_requirements,
      skills: item.skills_requirements,
      budgetFee: item.budget,
      settlementMethod: item.settlement_method,
      budgetDesc: '',
      remark: item.remark,
      status: item.status,
      submitTime: ''
    }))
  } catch (e) {
    ElMessage.error('加载计划列表失败，请检查后端服务')
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.section-title {
  margin: 20px 0 10px;
  font-weight: bold;
  font-size: 16px;
  border-left: 4px solid #409EFF;
  padding-left: 10px;
}
.filter-container {
  margin-bottom: 20px;
}
</style>
