import 'package:flutter/material.dart';

class IconMapper {
  static IconData getIcon(String iconName) {
    switch (iconName) {
      // Categories
      case 'tech_icon':
      case 'science':
        return Icons.science_outlined;
      case 'medical_services':
        return Icons.medical_services_outlined;
      case 'palette':
        return Icons.palette_outlined;
      case 'business_center':
        return Icons.business_center_outlined;
      case 'gavel':
        return Icons.gavel_outlined;
      case 'school':
        return Icons.school_outlined;
      case 'record_voice_over':
        return Icons.record_voice_over_outlined;
      case 'sports_soccer':
        return Icons.sports_soccer_outlined;

      // Sub-careers
      case 'code':
        return Icons.code;
      case 'analytics':
        return Icons.analytics_outlined;
      case 'psychology':
        return Icons.psychology_outlined;
      case 'security':
        return Icons.security;
      case 'precision_manufacturing':
        return Icons.precision_manufacturing_outlined;
      case 'stethoscope':
        return Icons.medical_information_outlined;
      case 'content_cut':
        return Icons.content_cut;
      case 'health_and_safety':
        return Icons.health_and_safety_outlined;
      case 'medication':
        return Icons.medication_outlined;
      case 'brush':
        return Icons.brush_outlined;
      case 'apparel':
        return Icons.checkroom_outlined;
      case 'apartment':
        return Icons.apartment_outlined;
      case 'movie':
        return Icons.movie_outlined;
      case 'chair':
        return Icons.chair_outlined;
      case 'rocket_launch':
        return Icons.rocket_launch_outlined;
      case 'trending_up':
        return Icons.trending_up;
      case 'account_balance':
        return Icons.account_balance_outlined;
      case 'campaign':
        return Icons.campaign_outlined;
      case 'groups':
        return Icons.groups_outlined;
      case 'balance':
        return Icons.balance_outlined;
      case 'local_police':
        return Icons.local_police_outlined;
      case 'history_edu':
        return Icons.history_edu_outlined;
      case 'volunteer_activism':
        return Icons.volunteer_activism_outlined;
      case 'accessibility':
        return Icons.accessibility_new_outlined;
      case 'person_search':
        return Icons.person_search_outlined;
      case 'newspaper':
        return Icons.newspaper_outlined;
      case 'videocam':
        return Icons.videocam_outlined;
      case 'perm_device_information':
        return Icons.info_outline;
      case 'public':
        return Icons.public_outlined;
      case 'edit_note':
        return Icons.edit_note_outlined;
      case 'sports_score':
        return Icons.sports_score_outlined;
      case 'sports':
        return Icons.sports_outlined;
      case 'fitness_center':
        return Icons.fitness_center_outlined;
      
      default:
        return Icons.folder_open_outlined;
    }
  }
}
