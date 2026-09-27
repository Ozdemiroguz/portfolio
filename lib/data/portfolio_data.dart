// Local portfolio data - Firebase yerine kullanılacak const veri

import 'package:portfolio/data/portfolio_info_data.dart';
import 'package:portfolio/data/apps_home_data.dart';
import 'package:portfolio/data/apps_bottom_data.dart';
import 'package:portfolio/data/apps_folder_data.dart';

const Map<String, dynamic> portfolioData = {
  'oguz': {
    'portfolio': portfolioInfo,
    'folders': portfolioFolders,
    'apps_home': appsHome,
    'apps_bottom': appsBottom,
    'apps_folder': appsFolder,
  },
};
