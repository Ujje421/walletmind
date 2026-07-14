import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// All transaction categories with icons, colors, and keywords for auto-classification.
enum TransactionCategory {
  food(
    label: 'Food & Drinks',
    icon: Icons.restaurant_rounded,
    color: AppColors.categoryFood,
    keywords: [
      'coffee', 'lunch', 'dinner', 'breakfast', 'snack', 'tea', 'pizza',
      'burger', 'biryani', 'swiggy', 'zomato', 'starbucks', 'dominos',
      'mcdonalds', 'kfc', 'subway', 'food', 'restaurant', 'cafe', 'eat',
      'meal', 'juice', 'smoothie', 'ice cream', 'dessert', 'bakery',
      'dine', 'takeaway', 'delivery', 'cooking', 'groceries', 'grocery',
      'vegetables', 'fruits', 'milk', 'bread', 'rice', 'dal', 'eggs',
      'chicken', 'mutton', 'fish', 'meat', 'oil', 'sugar', 'flour',
      'spices', 'snacks', 'biscuits', 'chocolate', 'chips', 'noodles',
    ],
  ),
  transport(
    label: 'Transport',
    icon: Icons.directions_car_rounded,
    color: AppColors.categoryTransport,
    keywords: [
      'uber', 'ola', 'rapido', 'cab', 'taxi', 'auto', 'rickshaw',
      'petrol', 'diesel', 'fuel', 'gas', 'cng', 'parking', 'toll',
      'metro', 'bus', 'train', 'flight', 'ticket', 'fare', 'ride',
      'commute', 'transport', 'travel', 'car wash', 'service',
    ],
  ),
  bills(
    label: 'Bills & Utilities',
    icon: Icons.receipt_long_rounded,
    color: AppColors.categoryBills,
    keywords: [
      'electricity', 'electric', 'power', 'water bill', 'gas bill',
      'phone bill', 'mobile bill', 'recharge', 'broadband', 'wifi',
      'internet bill', 'cable', 'dth', 'utility', 'municipal',
      'maintenance', 'society', 'bill',
    ],
  ),
  salary(
    label: 'Salary',
    icon: Icons.account_balance_wallet_rounded,
    color: AppColors.categorySalary,
    keywords: [
      'salary', 'paycheck', 'wages', 'bonus', 'stipend', 'incentive',
      'commission', 'overtime', 'pay',
    ],
  ),
  investment(
    label: 'Investment',
    icon: Icons.trending_up_rounded,
    color: AppColors.categoryInvestment,
    keywords: [
      'stock', 'mutual fund', 'sip', 'fd', 'fixed deposit', 'ppf',
      'nps', 'epf', 'gold', 'crypto', 'bitcoin', 'share', 'dividend',
      'interest', 'investment', 'invest', 'trading', 'bonds', 'demat',
      'zerodha', 'groww', 'upstox',
    ],
  ),
  entertainment(
    label: 'Entertainment',
    icon: Icons.movie_rounded,
    color: AppColors.categoryEntertainment,
    keywords: [
      'movie', 'netflix', 'spotify', 'youtube', 'prime', 'hotstar',
      'disney', 'hbo', 'gaming', 'game', 'concert', 'show', 'event',
      'party', 'club', 'bar', 'pub', 'entertainment', 'music',
      'streaming', 'apple music', 'jio cinema',
    ],
  ),
  medical(
    label: 'Medical',
    icon: Icons.local_hospital_rounded,
    color: AppColors.categoryMedical,
    keywords: [
      'medicine', 'doctor', 'hospital', 'clinic', 'pharmacy', 'medical',
      'health', 'dental', 'eye', 'lab', 'test', 'scan', 'xray',
      'surgery', 'therapy', 'consultation', 'prescription', 'apollo',
      'practo', 'netmeds', 'pharmeasy', '1mg',
    ],
  ),
  shopping(
    label: 'Shopping',
    icon: Icons.shopping_bag_rounded,
    color: AppColors.categoryShopping,
    keywords: [
      'amazon', 'flipkart', 'myntra', 'ajio', 'shopping', 'clothes',
      'shoes', 'gadget', 'phone', 'laptop', 'electronics', 'appliance',
      'furniture', 'decor', 'fashion', 'accessories', 'watch', 'bag',
      'cosmetics', 'makeup', 'skincare', 'gift', 'book', 'stationery',
    ],
  ),
  travel(
    label: 'Travel',
    icon: Icons.flight_rounded,
    color: AppColors.categoryTravel,
    keywords: [
      'hotel', 'airbnb', 'oyo', 'booking', 'resort', 'vacation',
      'trip', 'travel', 'tour', 'holiday', 'visa', 'passport',
      'luggage', 'sightseeing', 'makemytrip', 'goibibo', 'irctc',
    ],
  ),
  education(
    label: 'Education',
    icon: Icons.school_rounded,
    color: AppColors.categoryEducation,
    keywords: [
      'course', 'tuition', 'school', 'college', 'university', 'fees',
      'book', 'udemy', 'coursera', 'class', 'coaching', 'tutorial',
      'exam', 'certificate', 'education', 'study', 'library', 'learn',
    ],
  ),
  taxes(
    label: 'Taxes',
    icon: Icons.account_balance_rounded,
    color: AppColors.categoryTaxes,
    keywords: ['tax', 'gst', 'income tax', 'tds', 'cess', 'filing'],
  ),
  insurance(
    label: 'Insurance',
    icon: Icons.shield_rounded,
    color: AppColors.categoryInsurance,
    keywords: [
      'insurance', 'premium', 'lic', 'term', 'health insurance',
      'car insurance', 'policy', 'claim',
    ],
  ),
  family(
    label: 'Family',
    icon: Icons.family_restroom_rounded,
    color: AppColors.categoryFamily,
    keywords: [
      'dad', 'mom', 'father', 'mother', 'parent', 'brother', 'sister',
      'family', 'wife', 'husband', 'kid', 'child', 'baby', 'son',
      'daughter', 'relative', 'gift',
    ],
  ),
  pets(
    label: 'Pets',
    icon: Icons.pets_rounded,
    color: AppColors.categoryPets,
    keywords: [
      'pet', 'dog', 'cat', 'vet', 'veterinary', 'pet food', 'grooming',
      'animal',
    ],
  ),
  subscriptions(
    label: 'Subscriptions',
    icon: Icons.autorenew_rounded,
    color: AppColors.categorySubscriptions,
    keywords: [
      'subscription', 'recurring', 'membership', 'plan', 'monthly',
      'annual', 'renewal',
    ],
  ),
  rent(
    label: 'Rent',
    icon: Icons.home_rounded,
    color: AppColors.categoryRent,
    keywords: ['rent', 'lease', 'tenant', 'landlord', 'housing', 'pg'],
  ),
  gym(
    label: 'Gym & Fitness',
    icon: Icons.fitness_center_rounded,
    color: AppColors.categoryGym,
    keywords: [
      'gym', 'fitness', 'workout', 'yoga', 'sports', 'swimming',
      'running', 'marathon',
    ],
  ),
  internet(
    label: 'Internet',
    icon: Icons.wifi_rounded,
    color: AppColors.categoryInternet,
    keywords: [
      'internet', 'wifi', 'broadband', 'jio', 'airtel', 'vi',
      'bsnl', 'data pack',
    ],
  ),
  water(
    label: 'Water',
    icon: Icons.water_drop_rounded,
    color: AppColors.categoryWater,
    keywords: ['water', 'water bill', 'mineral water', 'can'],
  ),
  freelance(
    label: 'Freelance',
    icon: Icons.work_rounded,
    color: AppColors.income,
    keywords: [
      'freelance', 'project', 'client', 'gig', 'contract', 'consulting',
      'freelancing', 'side hustle',
    ],
  ),
  other(
    label: 'Other',
    icon: Icons.more_horiz_rounded,
    color: AppColors.categoryOther,
    keywords: [],
  );

  const TransactionCategory({
    required this.label,
    required this.icon,
    required this.color,
    required this.keywords,
  });

  final String label;
  final IconData icon;
  final Color color;
  final List<String> keywords;

  /// Find the best matching category for a given text.
  static TransactionCategory classify(String text) {
    final lower = text.toLowerCase();
    TransactionCategory best = TransactionCategory.other;
    int bestScore = 0;

    for (final cat in TransactionCategory.values) {
      if (cat == TransactionCategory.other) continue;
      int score = 0;
      for (final keyword in cat.keywords) {
        if (lower.contains(keyword)) {
          // Longer keyword matches are more specific → higher score
          score += keyword.length;
        }
      }
      if (score > bestScore) {
        bestScore = score;
        best = cat;
      }
    }
    return best;
  }
}
