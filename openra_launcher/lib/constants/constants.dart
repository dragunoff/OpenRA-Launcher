// TODO: Split constants into several classes/files/groups
class Constants {
  static const appName = 'OpenRA Launcher';
  static const iconSize = 32.0;
  static const iconSize2x = 64.0;
  static const iconSize3x = 96.0;
  static const spacing = 8.0;
  static const spacing2x = 16.0;
  static const tooltipWaitDuration = Duration(milliseconds: 600);
  static const officialModIds = ['cnc', 'd2k', 'ra'];
  static const devModVersion = '{DEV_VERSION}';
  static const modRepos = {
    'openra': '/OpenRA/OpenRA',
    'hv': '/OpenHV/OpenHV',
    'sp': '/ABrandau/Shattered-Paradise-SDK',
    'rv': '/MustaphaTR/Romanovs-Vengeance',
    'ca': '/Inq8/CAmod',
    'd2': '/OpenRA/d2',
    'raclassic': '/OpenRA/raclassic',
    'gen': '/MustaphaTR/Generals-Alpha',
    'mtrsd2k2': '/MustaphaTR/MustaphaTR-s-D2K-Mod',
    'ss': '/MustaphaTR/sole-survivor',
    'sa': '/Dzierzan/OpenSA',
    'cameo': '/Zeruel87/Cameo-mod',
    'tda': '/KOYK/OpenRA-Tiberian-Dawn-Apolyton',
    'openkrush_gen1': '/IceReaper/OpenKrush',
    'raplus': '/MlemandPurrs/raplusmod',
    'ta': '/EoralMilk/TiberianAurora'
  };
  static const githubApiUrl = 'https://api.github.com';
  static const githubReposEndpoint = '/repos';
  static const githubReleasesEndpoint = '/releases';
  static const appRepo = '/dragunoff/OpenRA-Launcher';
}
