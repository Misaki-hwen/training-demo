import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    redirect: '/enterprise'
  },
  {
    path: '/enterprise',
    name: 'Enterprise',
    component: () => import('../views/Enterprise/EnterpriseLayout.vue')
  },
  {
    path: '/operation',
    name: 'Operation',
    component: () => import('../views/Operation/OperationLayout.vue')
  },
  {
    path: '/school',
    name: 'School',
    component: () => import('../views/School/SchoolLayout.vue')
  },
  {
    path: '/student',
    name: 'Student',
    component: () => import('../views/Student/StudentLayout.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
