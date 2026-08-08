class Routes {
  // Common
  static const String home = '/';
  static const String choice = '/choice';

  // Admin Authentication
  static const String adminLogin = '/admin/login';
  static const String adminResetPassword = '/admin/reset_password';
  static const String adminSignup = '/admin/signup';
  static const String adminVerification = '/admin/verification';

  // Admin Dashboard & Management
  static const String adminMain = '/admin/main';
  
  // Admin Children
  static const String adminChildrenAdd = '/admin/children/add';
  static const String adminChildrenAddGoals = '/admin/children/add/goals';
  static const String adminChildrenAddGoalsDetail = '/admin/children/add/goals/detail';
  
  static const String adminChildrenDetails = '/admin/children/details';
  static const String adminChildrenDetailsAll = '/admin/children/details/all';
  static const String adminChildrenDetailsInfo = '/admin/children/details/info';
  static const String adminChildrenDetailsAiResults = '/admin/children/details/ai_results';
  static const String adminChildrenDetailsDailyNotes = '/admin/children/details/daily_notes';
  
  static const String adminChildrenSessions = '/admin/children/sessions';
  static const String adminChildrenSessionsChooseTasks = '/admin/children/sessions/choose_tasks';
  static const String adminChildrenSessionsRateTask = '/admin/children/sessions/rate_task';

  // Parent Authentication
  static const String parentLogin = '/parent/login';

  // Parent Dashboard & Features
  static const String parentMain = '/parent/main';
  static const String parentGlobalChat = '/parent/global_chat';
  static const String parentChat = '/parent/chat';
  static const String parentChildGoals = '/parent/child_goals';
  static const String parentSessionSchedule = '/parent/session_schedule';
}
