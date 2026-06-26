'use client';

import { useState, useEffect } from 'react';
import { motion, useScroll, useTransform, useInView } from 'framer-motion';
import { 
  Play, 
  MapPin, 
  Trophy, 
  Users, 
  Activity,
  ChevronRight,
  Star,
  Zap,
  Target,
  Menu,
  X,
  ArrowRight,
  CheckCircle,
  Sparkles,
  TrendingUp,
  Heart,
  Award,
  Smartphone,
  Flame,
  Watch,
  BarChart3,
  Clock,
  Globe,
  Shield,
  Headphones,
  Dumbbell,
  Footprints
} from 'lucide-react';

export default function Home() {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const { scrollY } = useScroll();
  const y1 = useTransform(scrollY, [0, 500], [0, -100]);
  const y2 = useTransform(scrollY, [0, 500], [0, 100]);
  const opacity = useTransform(scrollY, [0, 300], [1, 0]);

  const features = [
    {
      icon: <Activity className="w-8 h-8" />,
      title: 'Precision GPS Tracking',
      description: 'Military-grade GPS accuracy with real-time pace, distance, and elevation tracking for every activity',
      gradient: 'from-blue-500 via-cyan-500 to-teal-500',
      metric: '99.9%',
      metricLabel: 'Accuracy'
    },
    {
      icon: <MapPin className="w-8 h-8" />,
      title: '3D Terrain Maps',
      description: 'Explore stunning 3D maps with detailed elevation profiles, heat maps, and AI-powered route optimization',
      gradient: 'from-purple-500 via-pink-500 to-rose-500',
      metric: '10M+',
      metricLabel: 'Routes'
    },
    {
      icon: <Trophy className="w-8 h-8" />,
      title: 'Worldwide Virtual Events',
      description: 'Compete in global virtual races, earn exclusive medals, and unlock achievements with athletes worldwide',
      gradient: 'from-orange-500 via-red-500 to-pink-500',
      metric: '1000+',
      metricLabel: 'Events'
    },
    {
      icon: <Users className="w-8 h-8" />,
      title: 'Vibrant Community',
      description: 'Connect with 500K+ fitness enthusiasts, share progress, join challenges, and motivate each other',
      gradient: 'from-green-500 via-emerald-500 to-teal-500',
      metric: '500K+',
      metricLabel: 'Members'
    },
    {
      icon: <Zap className="w-8 h-8" />,
      title: 'AI Personal Coach',
      description: 'Get intelligent training plans, real-time form correction, and adaptive workouts powered by advanced AI',
      gradient: 'from-yellow-500 via-orange-500 to-red-500',
      metric: '24/7',
      metricLabel: 'Support'
    },
    {
      icon: <Target className="w-8 h-8" />,
      title: 'Smart Analytics',
      description: 'Track progress with beautiful charts, set intelligent goals, and celebrate every milestone achieved',
      gradient: 'from-indigo-500 via-purple-500 to-pink-500',
      metric: '95%',
      metricLabel: 'Success'
    },
  ];

  const stats = [
    { value: '500K+', label: 'Active Users', icon: Users, color: 'from-blue-500 to-cyan-500' },
    { value: '2M+', label: 'Activities', icon: Activity, color: 'from-purple-500 to-pink-500' },
    { value: '1000+', label: 'Events', icon: Trophy, color: 'from-orange-500 to-red-500' },
    { value: '4.9★', label: 'Rating', icon: Star, color: 'from-yellow-500 to-orange-500' },
  ];

  const testimonials = [
    {
      name: 'Sarah Johnson',
      role: 'Marathon Runner',
      image: 'SJ',
      text: 'MoveTrack completely transformed my training. The AI coaching helped me shave 15 minutes off my marathon time. The community support is incredible!',
      rating: 5,
      achievement: 'Boston Marathon Finisher'
    },
    {
      name: 'Mike Chen',
      role: 'Fitness Enthusiast',
      image: 'MC',
      text: 'Best fitness app I\'ve ever used. The virtual events and challenges keep me motivated daily. Lost 30 pounds and gained a whole new lifestyle!',
      rating: 5,
      achievement: 'Lost 30 lbs in 6 Months'
    },
    {
      name: 'Emily Davis',
      role: 'Casual Runner',
      image: 'ED',
      text: 'Never thought I\'d love running until MoveTrack. The gamification makes it addictive! Now I run 5K every morning without fail. 100-day streak!',
      rating: 5,
      achievement: '100 Day Streak'
    },
  ];

  const howItWorks = [
    {
      step: '01',
      title: 'Download & Sign Up',
      description: 'Get the app and create your profile in seconds with social login',
      icon: Smartphone,
      color: 'from-blue-500 to-cyan-500'
    },
    {
      step: '02',
      title: 'Set Your Goals',
      description: 'Define your fitness objectives and let AI create your personalized plan',
      icon: Target,
      color: 'from-purple-500 to-pink-500'
    },
    {
      step: '03',
      title: 'Start Training',
      description: 'Begin your journey with real-time coaching and smart feedback',
      icon: Zap,
      color: 'from-orange-500 to-red-500'
    },
    {
      step: '04',
      title: 'Track & Improve',
      description: 'Monitor progress with beautiful analytics and celebrate wins',
      icon: TrendingUp,
      color: 'from-green-500 to-emerald-500'
    },
  ];

  const pricingPlans = [
    {
      name: 'Free',
      price: '$0',
      period: 'forever',
      features: ['Basic Activity Tracking', '5 Virtual Events/month', 'Community Access', 'Basic Analytics', 'Standard Support'],
      cta: 'Get Started Free',
      popular: false
    },
    {
      name: 'Pro',
      price: '$9.99',
      period: '/month',
      features: ['Advanced GPS Tracking', 'Unlimited Events', 'AI Coaching', 'Detailed Analytics', 'Custom Plans', 'Priority Support', 'No Ads'],
      cta: 'Start 7-Day Trial',
      popular: true
    },
    {
      name: 'Elite',
      price: '$19.99',
      period: '/month',
      features: ['Everything in Pro', '1-on-1 Coaching', 'Race Strategy Plans', 'Nutrition Guidance', 'Exclusive Events', 'VIP Support', 'Early Access'],
      cta: 'Go Elite',
      popular: false
    },
  ];

  return (
    <div className="min-h-screen bg-white dark:bg-gray-900 overflow-x-hidden">
      {/* Navigation */}
      <motion.nav 
        initial={{ y: -100 }}
        animate={{ y: 0 }}
        transition={{ duration: 0.6, ease: 'easeOut' }}
        className="fixed top-0 left-0 right-0 z-50 bg-white/95 dark:bg-gray-900/95 backdrop-blur-xl border-b border-gray-200/50 dark:border-gray-700/50 shadow-sm"
      >
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-20">
            <div className="flex items-center gap-3">
              <div className="relative group cursor-pointer">
                <div className="absolute inset-0 bg-gradient-to-r from-primary to-secondary rounded-xl blur-lg opacity-50 group-hover:opacity-75 transition-opacity"></div>
                <div className="relative w-12 h-12 bg-gradient-to-br from-primary to-secondary rounded-xl flex items-center justify-center shadow-lg">
                  <Activity className="w-7 h-7 text-white" />
                </div>
              </div>
              <span className="text-2xl font-bold bg-gradient-to-r from-primary via-purple-600 to-secondary bg-clip-text text-transparent">
                MoveTrack
              </span>
            </div>

            <div className="hidden md:flex items-center gap-8">
              <a href="#features" className="text-gray-700 dark:text-gray-300 hover:text-primary-600 dark:hover:text-primary-400 transition-colors font-medium">Features</a>
              <a href="#how-it-works" className="text-gray-700 dark:text-gray-300 hover:text-primary-600 dark:hover:text-primary-400 transition-colors font-medium">How It Works</a>
              <a href="#testimonials" className="text-gray-700 dark:text-gray-300 hover:text-primary-600 dark:hover:text-primary-400 transition-colors font-medium">Testimonials</a>
              <a href="#pricing" className="text-gray-700 dark:text-gray-300 hover:text-primary-600 dark:hover:text-primary-400 transition-colors font-medium">Pricing</a>
              <button className="px-6 py-2.5 text-gray-700 dark:text-gray-300 font-semibold hover:text-primary-600 dark:hover:text-primary-400 transition-colors">
                Sign In
              </button>
              <button className="px-6 py-2.5 bg-gradient-to-r from-primary to-secondary text-white rounded-full font-semibold hover:shadow-lg hover:shadow-primary-500/50 transition-all">
                Get Started
              </button>
            </div>

            <button 
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              className="md:hidden p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800"
            >
              {mobileMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </button>
          </div>
        </div>

        {/* Mobile Menu */}
        {mobileMenuOpen && (
          <motion.div
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            className="md:hidden bg-white dark:bg-gray-900 border-b border-gray-200 dark:border-gray-700"
          >
            <div className="px-4 py-6 space-y-4">
              <a href="#features" className="block text-gray-700 dark:text-gray-300 hover:text-primary-600 font-medium">Features</a>
              <a href="#how-it-works" className="block text-gray-700 dark:text-gray-300 hover:text-primary-600 font-medium">How It Works</a>
              <a href="#testimonials" className="block text-gray-700 dark:text-gray-300 hover:text-primary-600 font-medium">Testimonials</a>
              <a href="#pricing" className="block text-gray-700 dark:text-gray-300 hover:text-primary-600 font-medium">Pricing</a>
              <button className="w-full px-6 py-3 text-gray-700 dark:text-gray-300 font-semibold border border-gray-300 dark:border-gray-600 rounded-full">
                Sign In
              </button>
              <button className="w-full px-6 py-3 bg-gradient-to-r from-primary to-secondary text-white rounded-full font-semibold">
                Get Started
              </button>
            </div>
          </motion.div>
        )}
      </motion.nav>

      {/* Hero Section */}
      <section className="relative pt-32 pb-20 sm:pt-40 sm:pb-32 overflow-hidden">
        {/* Animated Background */}
        <div className="absolute inset-0 overflow-hidden">
          <motion.div 
            style={{ y: y1 }}
            className="absolute -top-40 -right-40 w-96 h-96 bg-gradient-to-br from-primary-400/40 to-secondary-400/40 rounded-full blur-3xl animate-pulse"
          />
          <motion.div 
            style={{ y: y2 }}
            className="absolute top-1/2 -left-40 w-96 h-96 bg-gradient-to-br from-purple-400/40 to-pink-400/40 rounded-full blur-3xl animate-pulse"
            animate={{ scale: [1, 1.2, 1] }}
            transition={{ duration: 4, repeat: Infinity }}
          />
          <motion.div 
            style={{ y: y1 }}
            className="absolute bottom-0 right-1/4 w-96 h-96 bg-gradient-to-br from-cyan-400/40 to-blue-400/40 rounded-full blur-3xl animate-pulse"
            animate={{ scale: [1, 1.1, 1] }}
            transition={{ duration: 3, repeat: Infinity }}
          />
        </div>

        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8 }}
            className="text-center"
          >
            {/* Badge */}
            <motion.div
              initial={{ scale: 0.8, opacity: 0, y: 20 }}
              animate={{ scale: 1, opacity: 1, y: 0 }}
              transition={{ delay: 0.2, type: "spring", stiffness: 200 }}
              className="inline-flex items-center gap-2 px-6 py-3 bg-gradient-to-r from-primary/10 to-secondary/10 rounded-full border border-primary/20 mb-8 shadow-lg backdrop-blur-sm"
            >
              <motion.div
                animate={{ rotate: [0, 360] }}
                transition={{ duration: 3, repeat: Infinity, ease: "linear" }}
              >
                <Sparkles className="w-5 h-5 text-primary-600" />
              </motion.div>
              <span className="text-sm font-bold bg-gradient-to-r from-primary-700 to-secondary-700 dark:from-primary-300 dark:to-secondary-300 bg-clip-text text-transparent">
                #1 Fitness App of 2024
              </span>
            </motion.div>

            {/* Main Heading */}
            <h1 className="text-5xl sm:text-6xl lg:text-7xl xl:text-8xl font-bold tracking-tight text-gray-900 dark:text-white mb-8 leading-tight">
              Transform Your
              <br />
              <motion.span 
                className="bg-gradient-to-r from-primary via-purple-600 to-secondary bg-clip-text text-transparent inline-block"
                animate={{ 
                  backgroundPosition: ["0% center", "100% center", "0% center"],
                }}
                transition={{ 
                  duration: 5, 
                  repeat: Infinity,
                  ease: "easeInOut"
                }}
                style={{ backgroundSize: "200% auto" }}
              >
                Fitness Journey
              </motion.span>
            </h1>

            {/* Subtitle */}
            <motion.p 
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.4 }}
              className="text-xl sm:text-2xl text-gray-600 dark:text-gray-300 mb-12 max-w-4xl mx-auto leading-relaxed"
            >
              The ultimate platform for tracking activities, joining virtual events, and achieving your fitness goals with AI-powered insights
            </motion.p>

            {/* CTA Buttons */}
            <motion.div 
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.6 }}
              className="flex flex-col sm:flex-row gap-4 justify-center mb-16"
            >
              <motion.button
                whileHover={{ scale: 1.05, y: -2 }}
                whileTap={{ scale: 0.95 }}
                className="group relative px-8 py-4 bg-gradient-to-r from-primary to-secondary text-white rounded-full font-bold text-lg shadow-2xl hover:shadow-primary-500/50 transition-all overflow-hidden"
              >
                <div className="absolute inset-0 bg-gradient-to-r from-primary via-purple-600 to-secondary opacity-0 group-hover:opacity-100 transition-opacity"></div>
                <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent translate-x-[-100%] group-hover:translate-x-[100%] transition-transform duration-700"></div>
                <div className="relative flex items-center gap-2">
                  <Play className="w-5 h-5" />
                  Start Free Trial
                  <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
                </div>
              </motion.button>
              <motion.button
                whileHover={{ scale: 1.05, y: -2 }}
                whileTap={{ scale: 0.95 }}
                className="px-8 py-4 bg-white dark:bg-gray-800 text-gray-900 dark:text-white rounded-full font-bold text-lg shadow-xl hover:shadow-2xl transition-all border-2 border-gray-200 dark:border-gray-700 hover:border-primary-300 dark:hover:border-primary-600"
              >
                Watch Demo
              </motion.button>
            </motion.div>

            {/* Hero Image/Illustration */}
            <motion.div
              initial={{ opacity: 0, y: 50, scale: 0.95 }}
              animate={{ opacity: 1, y: 0, scale: 1 }}
              transition={{ delay: 0.5, duration: 0.8, type: "spring" }}
              className="relative max-w-5xl mx-auto"
            >
              <div className="relative rounded-3xl overflow-hidden shadow-2xl">
                <div className="absolute inset-0 bg-gradient-to-br from-primary-500/20 to-secondary-500/20 backdrop-blur-3xl"></div>
                <div className="absolute -inset-1 bg-gradient-to-r from-primary-500/50 to-secondary-500/50 rounded-3xl blur opacity-30 group-hover:opacity-100 transition duration-1000 group-hover:duration-200"></div>
                <div className="relative bg-gradient-to-br from-gray-900 to-gray-800 p-8 sm:p-12">
                  <div className="grid grid-cols-3 gap-4">
                    <motion.div 
                      whileHover={{ scale: 1.05 }}
                      className="col-span-2 bg-gradient-to-br from-primary-500/20 to-secondary-500/20 rounded-2xl p-6 backdrop-blur-xl border border-white/10 hover:border-primary-400/50 transition-all"
                    >
                      <div className="flex items-center justify-between mb-4">
                        <div className="text-white/80 text-sm font-medium">Today's Activity</div>
                        <motion.div
                          animate={{ rotate: [0, 360] }}
                          transition={{ duration: 20, repeat: Infinity, ease: "linear" }}
                        >
                          <Activity className="w-5 h-5 text-primary-400" />
                        </motion.div>
                      </div>
                      <div className="text-4xl font-bold text-white mb-2">8.5 km</div>
                      <div className="text-white/60 text-sm mb-4">Goal: 10 km</div>
                      <div className="h-2 bg-white/10 rounded-full overflow-hidden">
                        <motion.div 
                          className="h-full w-4/5 bg-gradient-to-r from-primary to-secondary rounded-full"
                          initial={{ width: 0 }}
                          animate={{ width: "85%" }}
                          transition={{ duration: 1.5, delay: 1 }}
                        ></motion.div>
                      </div>
                    </motion.div>
                    <motion.div 
                      whileHover={{ scale: 1.05 }}
                      className="bg-gradient-to-br from-green-500/20 to-emerald-500/20 rounded-2xl p-6 backdrop-blur-xl border border-white/10 hover:border-green-400/50 transition-all"
                    >
                      <motion.div
                        animate={{ scale: [1, 1.2, 1] }}
                        transition={{ duration: 1, repeat: Infinity }}
                      >
                        <Heart className="w-8 h-8 text-red-400 mb-3" />
                      </motion.div>
                      <div className="text-2xl font-bold text-white">142</div>
                      <div className="text-white/60 text-xs">BPM</div>
                    </motion.div>
                    <motion.div 
                      whileHover={{ scale: 1.05 }}
                      className="bg-gradient-to-br from-purple-500/20 to-pink-500/20 rounded-2xl p-6 backdrop-blur-xl border border-white/10 hover:border-purple-400/50 transition-all"
                    >
                      <motion.div
                        animate={{ y: [0, -5, 0] }}
                        transition={{ duration: 2, repeat: Infinity }}
                      >
                        <Trophy className="w-8 h-8 text-yellow-400 mb-3" />
                      </motion.div>
                      <div className="text-2xl font-bold text-white">12</div>
                      <div className="text-white/60 text-xs">Badges</div>
                    </motion.div>
                    <motion.div 
                      whileHover={{ scale: 1.05 }}
                      className="col-span-2 bg-gradient-to-br from-orange-500/20 to-red-500/20 rounded-2xl p-6 backdrop-blur-xl border border-white/10 hover:border-orange-400/50 transition-all"
                    >
                      <div className="flex items-center justify-between">
                        <div>
                          <div className="text-white/80 text-sm mb-1 font-medium">Calories Burned</div>
                          <div className="text-3xl font-bold text-white">1,247</div>
                        </div>
                        <motion.div
                          animate={{ rotate: [0, 10, -10, 0] }}
                          transition={{ duration: 2, repeat: Infinity }}
                        >
                          <Flame className="w-12 h-12 text-orange-400" />
                        </motion.div>
                      </div>
                    </motion.div>
                  </div>
                </div>
              </div>
            </motion.div>
          </motion.div>
        </div>
      </section>

      {/* Stats Section */}
      <section className="py-20 bg-gradient-to-br from-gray-50 to-gray-100 dark:from-gray-800 dark:to-gray-900 relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-mesh opacity-50"></div>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative">
          <div className="grid grid-cols-2 lg:grid-cols-4 gap-8">
            {stats.map((stat, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, y: 20, scale: 0.9 }}
                whileInView={{ opacity: 1, y: 0, scale: 1 }}
                viewport={{ once: true }}
                transition={{ delay: index * 0.1, type: "spring" }}
                whileHover={{ y: -5, scale: 1.05 }}
                className="text-center group cursor-pointer"
              >
                <div className="relative inline-flex items-center justify-center w-20 h-20 mb-4">
                  <div className="absolute inset-0 bg-gradient-to-br from-primary/20 to-secondary/20 rounded-2xl blur-xl group-hover:blur-2xl transition-all"></div>
                  <div className={`relative w-16 h-16 bg-gradient-to-br ${stat.color} rounded-2xl flex items-center justify-center shadow-lg group-hover:shadow-glow transition-all`}>
                    <stat.icon className="w-8 h-8 text-white" />
                  </div>
                </div>
                <motion.div 
                  className="text-4xl sm:text-5xl font-bold bg-gradient-to-r from-primary to-secondary bg-clip-text text-transparent mb-2"
                  whileHover={{ scale: 1.1 }}
                >
                  {stat.value}
                </motion.div>
                <div className="text-gray-600 dark:text-gray-400 font-medium">
                  {stat.label}
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="py-20 sm:py-32 relative">
        <div className="absolute inset-0 bg-gradient-mesh opacity-30"></div>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="text-center mb-20"
          >
            <motion.div 
              initial={{ scale: 0.8, opacity: 0 }}
              whileInView={{ scale: 1, opacity: 1 }}
              viewport={{ once: true }}
              className="inline-block mb-4"
            >
              <span className="px-6 py-3 bg-gradient-to-r from-primary/10 to-secondary/10 rounded-full text-sm font-bold text-primary-700 dark:text-primary-300 border border-primary/20 shadow-lg backdrop-blur-sm">
                ✨ POWERFUL FEATURES
              </span>
            </motion.div>
            <motion.h2 
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              className="text-4xl sm:text-5xl lg:text-6xl font-bold text-gray-900 dark:text-white mb-6"
            >
              Everything You Need to
              <br />
              <motion.span 
                className="bg-gradient-to-r from-primary via-purple-600 to-secondary bg-clip-text text-transparent inline-block"
                animate={{ 
                  backgroundPosition: ["0% center", "100% center", "0% center"],
                }}
                transition={{ 
                  duration: 5, 
                  repeat: Infinity,
                  ease: "easeInOut"
                }}
                style={{ backgroundSize: "200% auto" }}
              >
                Succeed
              </motion.span>
            </motion.h2>
            <motion.p 
              initial={{ opacity: 0 }}
              whileInView={{ opacity: 1 }}
              viewport={{ once: true }}
              transition={{ delay: 0.2 }}
              className="text-lg sm:text-xl text-gray-600 dark:text-gray-300 max-w-3xl mx-auto"
            >
              Powerful features designed to help you track, improve, and share your fitness journey
            </motion.p>
          </motion.div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {features.map((feature, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: index * 0.1, type: "spring" }}
                whileHover={{ y: -10, scale: 1.02 }}
                className="group relative"
              >
                <div className="absolute inset-0 bg-gradient-to-br from-primary-500/20 to-secondary-500/20 rounded-3xl blur-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
                <div className="relative bg-white dark:bg-gray-800 rounded-3xl p-8 shadow-xl hover:shadow-2xl transition-all duration-300 border border-gray-100 dark:border-gray-700 h-full hover:border-primary-300 dark:hover:border-primary-600">
                  <motion.div 
                    className={`inline-flex items-center justify-center w-16 h-16 bg-gradient-to-br ${feature.gradient} rounded-2xl mb-6 shadow-lg`}
                    whileHover={{ scale: 1.1, rotate: 5 }}
                    transition={{ type: "spring", stiffness: 300 }}
                  >
                    <div className="text-white">
                      {feature.icon}
                    </div>
                  </motion.div>
                  <h3 className="text-2xl font-bold text-gray-900 dark:text-white mb-3 group-hover:text-primary-600 dark:group-hover:text-primary-400 transition-colors">
                    {feature.title}
                  </h3>
                  <p className="text-gray-600 dark:text-gray-300 leading-relaxed mb-4">
                    {feature.description}
                  </p>
                  <motion.div 
                    className="inline-flex items-center gap-2 text-sm font-semibold text-primary-600 dark:text-primary-400 bg-primary-50 dark:bg-primary-900/20 px-3 py-1 rounded-full"
                    whileHover={{ scale: 1.05 }}
                  >
                    <CheckCircle className="w-4 h-4" />
                    {feature.metric} {feature.metricLabel}
                  </motion.div>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* How It Works Section */}
      <section id="how-it-works" className="py-20 sm:py-32 bg-gradient-to-br from-primary-50 via-purple-50 to-secondary-50 dark:from-gray-800 dark:via-gray-900 dark:to-gray-800 relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-mesh opacity-30"></div>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="text-center mb-20"
          >
            <motion.div 
              initial={{ scale: 0.8, opacity: 0 }}
              whileInView={{ scale: 1, opacity: 1 }}
              viewport={{ once: true }}
              className="inline-block mb-4"
            >
              <span className="px-6 py-3 bg-white dark:bg-gray-800 rounded-full text-sm font-bold text-primary-700 dark:text-primary-300 border border-primary/20 shadow-lg">
                🚀 HOW IT WORKS
              </span>
            </motion.div>
            <motion.h2 
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              className="text-4xl sm:text-5xl lg:text-6xl font-bold text-gray-900 dark:text-white mb-6"
            >
              Start Your Journey in
              <br />
              <motion.span 
                className="bg-gradient-to-r from-primary to-secondary bg-clip-text text-transparent inline-block"
                animate={{ 
                  backgroundPosition: ["0% center", "100% center", "0% center"],
                }}
                transition={{ 
                  duration: 5, 
                  repeat: Infinity,
                  ease: "easeInOut"
                }}
                style={{ backgroundSize: "200% auto" }}
              >
                4 Simple Steps
              </motion.span>
            </motion.h2>
          </motion.div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            {howItWorks.map((item, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: index * 0.2, type: "spring" }}
                whileHover={{ y: -8 }}
                className="relative"
              >
                <div className="bg-white dark:bg-gray-800 rounded-3xl p-8 shadow-xl hover:shadow-2xl transition-all duration-300 border border-gray-100 dark:border-gray-700 h-full hover:border-primary-300 dark:hover:border-primary-600 group">
                  <motion.div 
                    className={`inline-flex items-center justify-center w-16 h-16 bg-gradient-to-br ${item.color} rounded-2xl mb-6 shadow-lg`}
                    whileHover={{ scale: 1.1, rotate: 5 }}
                  >
                    <item.icon className="w-8 h-8 text-white" />
                  </motion.div>
                  <motion.div 
                    className="text-6xl font-bold bg-gradient-to-r from-primary/20 to-secondary/20 bg-clip-text text-transparent mb-4"
                    whileHover={{ scale: 1.1 }}
                  >
                    {item.step}
                  </motion.div>
                  <h3 className="text-xl font-bold text-gray-900 dark:text-white mb-3 group-hover:text-primary-600 dark:group-hover:text-primary-400 transition-colors">
                    {item.title}
                  </h3>
                  <p className="text-gray-600 dark:text-gray-300">
                    {item.description}
                  </p>
                </div>
                {index < howItWorks.length - 1 && (
                  <motion.div 
                    className="hidden lg:block absolute top-1/2 -right-4 transform -translate-y-1/2"
                    animate={{ x: [0, 5, 0] }}
                    transition={{ duration: 2, repeat: Infinity }}
                  >
                    <ArrowRight className="w-8 h-8 text-primary-400" />
                  </motion.div>
                )}
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Testimonials Section */}
      <section id="testimonials" className="py-20 sm:py-32 relative">
        <div className="absolute inset-0 bg-gradient-mesh opacity-30"></div>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="text-center mb-20"
          >
            <motion.div 
              initial={{ scale: 0.8, opacity: 0 }}
              whileInView={{ scale: 1, opacity: 1 }}
              viewport={{ once: true }}
              className="inline-block mb-4"
            >
              <span className="px-6 py-3 bg-gradient-to-r from-primary/10 to-secondary/10 rounded-full text-sm font-bold text-primary-700 dark:text-primary-300 border border-primary/20 shadow-lg backdrop-blur-sm">
                💬 TESTIMONIALS
              </span>
            </motion.div>
            <motion.h2 
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              className="text-4xl sm:text-5xl lg:text-6xl font-bold text-gray-900 dark:text-white mb-6"
            >
              Loved by
              <motion.span 
                className="bg-gradient-to-r from-primary to-secondary bg-clip-text text-transparent inline-block"
                animate={{ 
                  backgroundPosition: ["0% center", "100% center", "0% center"],
                }}
                transition={{ 
                  duration: 5, 
                  repeat: Infinity,
                  ease: "easeInOut"
                }}
                style={{ backgroundSize: "200% auto" }}
              >
                {" "}Thousands
              </motion.span>
            </motion.h2>
          </motion.div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {testimonials.map((testimonial, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: index * 0.2, type: "spring" }}
                whileHover={{ y: -8, scale: 1.02 }}
                className="bg-white dark:bg-gray-800 rounded-3xl p-8 shadow-xl hover:shadow-2xl transition-all duration-300 border border-gray-100 dark:border-gray-700 hover:border-primary-300 dark:hover:border-primary-600 group"
              >
                <div className="flex items-center gap-1 mb-4">
                  {[...Array(testimonial.rating)].map((_, i) => (
                    <motion.div
                      key={i}
                      initial={{ scale: 0 }}
                      whileInView={{ scale: 1 }}
                      viewport={{ once: true }}
                      transition={{ delay: index * 0.2 + i * 0.1 }}
                    >
                      <Star className="w-5 h-5 fill-yellow-400 text-yellow-400" />
                    </motion.div>
                  ))}
                </div>
                <p className="text-gray-700 dark:text-gray-300 mb-6 leading-relaxed italic">
                  "{testimonial.text}"
                </p>
                <div className="flex items-center gap-2 mb-4">
                  <Award className="w-4 h-4 text-yellow-500" />
                  <span className="text-xs font-semibold text-yellow-600 dark:text-yellow-400">{testimonial.achievement}</span>
                </div>
                <div className="flex items-center gap-4">
                  <motion.div 
                    className="w-12 h-12 bg-gradient-to-br from-primary to-secondary rounded-full flex items-center justify-center text-white font-bold shadow-lg"
                    whileHover={{ scale: 1.1, rotate: 5 }}
                  >
                    {testimonial.image}
                  </motion.div>
                  <div>
                    <div className="font-bold text-gray-900 dark:text-white group-hover:text-primary-600 dark:group-hover:text-primary-400 transition-colors">{testimonial.name}</div>
                    <div className="text-sm text-gray-600 dark:text-gray-400">{testimonial.role}</div>
                  </div>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Pricing Section */}
      <section id="pricing" className="py-20 sm:py-32 bg-gradient-to-br from-gray-50 to-gray-100 dark:from-gray-800 dark:to-gray-900 relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-mesh opacity-30"></div>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="text-center mb-20"
          >
            <motion.div 
              initial={{ scale: 0.8, opacity: 0 }}
              whileInView={{ scale: 1, opacity: 1 }}
              viewport={{ once: true }}
              className="inline-block mb-4"
            >
              <span className="px-6 py-3 bg-gradient-to-r from-primary/10 to-secondary/10 rounded-full text-sm font-bold text-primary-700 dark:text-primary-300 border border-primary/20 shadow-lg backdrop-blur-sm">
                💎 PRICING
              </span>
            </motion.div>
            <motion.h2 
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              className="text-4xl sm:text-5xl lg:text-6xl font-bold text-gray-900 dark:text-white mb-6"
            >
              Choose Your
              <motion.span 
                className="bg-gradient-to-r from-primary to-secondary bg-clip-text text-transparent inline-block"
                animate={{ 
                  backgroundPosition: ["0% center", "100% center", "0% center"],
                }}
                transition={{ 
                  duration: 5, 
                  repeat: Infinity,
                  ease: "easeInOut"
                }}
                style={{ backgroundSize: "200% auto" }}
              >
                {" "}Plan
              </motion.span>
            </motion.h2>
            <motion.p 
              initial={{ opacity: 0 }}
              whileInView={{ opacity: 1 }}
              viewport={{ once: true }}
              transition={{ delay: 0.2 }}
              className="text-lg sm:text-xl text-gray-600 dark:text-gray-300 max-w-2xl mx-auto"
            >
              Start free and upgrade when you're ready for more features
            </motion.p>
          </motion.div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-6xl mx-auto">
            {pricingPlans.map((plan, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: index * 0.1, type: "spring" }}
                whileHover={{ y: -8, scale: plan.popular ? 1.05 : 1.02 }}
                className={`relative bg-white dark:bg-gray-800 rounded-3xl p-8 shadow-xl hover:shadow-2xl transition-all duration-300 border-2 ${
                  plan.popular 
                    ? 'border-primary-500 dark:border-primary-400 scale-105' 
                    : 'border-gray-100 dark:border-gray-700'
                }`}
              >
                {plan.popular && (
                  <motion.div 
                    initial={{ scale: 0 }}
                    whileInView={{ scale: 1 }}
                    viewport={{ once: true }}
                    className="absolute -top-4 left-1/2 transform -translate-x-1/2"
                  >
                    <span className="px-4 py-1 bg-gradient-to-r from-primary to-secondary text-white text-sm font-bold rounded-full shadow-lg">
                      MOST POPULAR
                    </span>
                  </motion.div>
                )}
                <div className="text-center mb-6">
                  <h3 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">{plan.name}</h3>
                  <div className="flex items-baseline justify-center gap-1">
                    <span className="text-5xl font-bold bg-gradient-to-r from-primary to-secondary bg-clip-text text-transparent">
                      {plan.price}
                    </span>
                    <span className="text-gray-600 dark:text-gray-400">{plan.period}</span>
                  </div>
                </div>
                <ul className="space-y-4 mb-8">
                  {plan.features.map((feature, i) => (
                    <motion.li 
                      key={i} 
                      className="flex items-start gap-3"
                      initial={{ opacity: 0, x: -10 }}
                      whileInView={{ opacity: 1, x: 0 }}
                      viewport={{ once: true }}
                      transition={{ delay: index * 0.1 + i * 0.05 }}
                    >
                      <CheckCircle className="w-5 h-5 text-green-500 flex-shrink-0 mt-0.5" />
                      <span className="text-gray-700 dark:text-gray-300">{feature}</span>
                    </motion.li>
                  ))}
                </ul>
                <motion.button 
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                  className={`w-full py-3 rounded-full font-bold transition-all ${
                    plan.popular
                      ? 'bg-gradient-to-r from-primary to-secondary text-white hover:shadow-lg hover:shadow-primary-500/50'
                      : 'bg-gray-100 dark:bg-gray-700 text-gray-900 dark:text-white hover:bg-gray-200 dark:hover:bg-gray-600'
                  }`}
                >
                  {plan.cta}
                </motion.button>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 sm:py-32 relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-br from-primary-600 via-purple-600 to-secondary-600"></div>
        <div className="absolute inset-0">
          <motion.div 
            className="absolute top-0 left-0 w-96 h-96 bg-white/10 rounded-full blur-3xl"
            animate={{ scale: [1, 1.2, 1], x: [0, 50, 0] }}
            transition={{ duration: 8, repeat: Infinity }}
          ></motion.div>
          <motion.div 
            className="absolute bottom-0 right-0 w-96 h-96 bg-white/10 rounded-full blur-3xl"
            animate={{ scale: [1, 1.3, 1], x: [0, -50, 0] }}
            transition={{ duration: 10, repeat: Infinity }}
          ></motion.div>
        </div>
        
        <div className="relative max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            whileInView={{ opacity: 1, scale: 1 }}
            viewport={{ once: true }}
            transition={{ type: "spring" }}
          >
            <h2 className="text-4xl sm:text-5xl lg:text-6xl font-bold text-white mb-6">
              Ready to Start Your Journey?
            </h2>
            <p className="text-lg sm:text-xl text-white/90 mb-10 max-w-2xl mx-auto">
              Join over 500,000 users who are already transforming their fitness journey with MoveTrack
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <motion.button
                whileHover={{ scale: 1.05, y: -2 }}
                whileTap={{ scale: 0.95 }}
                className="px-10 py-5 bg-white text-primary-600 rounded-full font-bold text-lg shadow-2xl hover:shadow-3xl transition-all inline-flex items-center gap-2 group"
              >
                Get Started Free
                <motion.div
                  animate={{ x: [0, 5, 0] }}
                  transition={{ duration: 1.5, repeat: Infinity }}
                >
                  <ArrowRight className="w-5 h-5" />
                </motion.div>
              </motion.button>
              <motion.button
                whileHover={{ scale: 1.05, y: -2 }}
                whileTap={{ scale: 0.95 }}
                className="px-10 py-5 bg-white/10 backdrop-blur-lg text-white rounded-full font-bold text-lg shadow-xl hover:shadow-2xl transition-all border-2 border-white/20 hover:bg-white/20"
              >
                Contact Sales
              </motion.button>
            </div>
          </motion.div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-900 text-gray-300 py-16 relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-mesh opacity-20"></div>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-12 mb-12">
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
            >
              <div className="flex items-center gap-2 mb-4">
                <motion.div 
                  className="w-10 h-10 bg-gradient-to-br from-primary to-secondary rounded-xl flex items-center justify-center shadow-lg"
                  whileHover={{ scale: 1.1, rotate: 5 }}
                >
                  <Activity className="w-6 h-6 text-white" />
                </motion.div>
                <span className="text-2xl font-bold text-white">MoveTrack</span>
              </div>
              <p className="text-sm leading-relaxed mb-6">
                The modern fitness platform for walkers and runners. Track, improve, and share your journey.
              </p>
              <div className="flex gap-3">
                {[
                  <svg key="fb" className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"><path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/></svg>,
                  <svg key="tw" className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"><path d="M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z"/></svg>,
                  <svg key="gh" className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"><path d="M12 0C5.374 0 0 5.373 0 12c0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23A11.509 11.509 0 0112 5.803c1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576C20.566 21.797 24 17.3 24 12c0-6.627-5.373-12-12-12z"/></svg>
                ].map((icon, i) => (
                  <motion.div
                    key={i}
                    whileHover={{ scale: 1.1, y: -2 }}
                    className="w-10 h-10 bg-gray-800 hover:bg-gradient-to-br hover:from-primary hover:to-secondary rounded-full flex items-center justify-center transition-all cursor-pointer"
                  >
                    {icon}
                  </motion.div>
                ))}
              </div>
            </motion.div>
            {[
              { title: 'Product', links: ['Features', 'Pricing', 'Download', 'Integrations'] },
              { title: 'Company', links: ['About', 'Blog', 'Careers', 'Contact'] },
              { title: 'Legal', links: ['Privacy', 'Terms', 'Security', 'Cookies'] }
            ].map((column, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: index * 0.1 }}
              >
                <h4 className="text-white font-bold text-lg mb-6">{column.title}</h4>
                <ul className="space-y-3 text-sm">
                  {column.links.map((link, i) => (
                    <li key={i}>
                      <a href="#" className="hover:text-primary-400 transition-colors flex items-center gap-2 group">
                        <ChevronRight className="w-4 h-4 opacity-0 group-hover:opacity-100 transition-opacity" />
                        {link}
                      </a>
                    </li>
                  ))}
                </ul>
              </motion.div>
            ))}
          </div>
          <motion.div 
            initial={{ opacity: 0 }}
            whileInView={{ opacity: 1 }}
            viewport={{ once: true }}
            className="border-t border-gray-800 pt-8 text-center text-sm"
          >
            <p>&copy; 2024 MoveTrack. All rights reserved. Made with ❤️ for fitness enthusiasts.</p>
          </motion.div>
        </div>
      </footer>
    </div>
  );
}