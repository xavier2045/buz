import { Ref } from 'vue';

// 许可证类型定义
export type LicenseType = 'open' | 'non-commercial' | 'commercial' | 'commercial-remix' | 'custom';

// 许可证分类定义
export interface LicenseCategory {
  id: string;
  name: string;
  description: string;
  licenses: LicenseType[];
}

// 许可证冲突定义
export interface LicenseConflict {
  hasConflict: boolean;
  conflictingLicenses: string[];
  reason: string;
  suggestions?: string[];
}

// 许可证属性选项
export interface LicenseOption {
  id: string;
  value: string;
  incompatibleWith: { licenseType: LicenseType, reason: string }[];
}

// 许可证规则集
const INCOMPATIBLE_RULES: Record<string, string[]> = {
  // 开放使用与所有其他许可证互斥
  'open': ['commercial', 'commercial-remix', 'non-commercial', 'custom'],
  
  // 非商业使用与商业使用互斥
  'non-commercial': ['commercial', 'commercial-remix'],
  
  // 商业使用与非商业使用互斥
  'commercial': ['non-commercial'],
  
  // 商业混音与非商业使用互斥
  'commercial-remix': ['non-commercial'],
  
  // 自定义许可证规则取决于其设置
  'custom': [] // 这会基于具体的自定义设置动态计算
};

// 许可证设置冲突规则
type OptionConflictMap = {
  [key: string]: {
    [value: string]: {
      [licenseType: string]: string
    }
  }
};

const OPTION_CONFLICTS: OptionConflictMap = {
  'attribution': {
    'required': { 'open': '开放使用许可证不能要求归属' }
  },
  'remixing': {
    'prohibited': { 
      'open': '开放使用许可证不能禁止混音',
      'non-commercial': '非商业混音许可证不能禁止混音',
      'commercial-remix': '商业混音许可证不能禁止混音'
    }
  },
  'commercial-use': {
    'prohibited': { 'open': '开放使用许可证不能禁止商业使用', 'commercial': '商业使用许可证不能禁止商业使用' },
    'allowed': { 'non-commercial': '非商业混音许可证不能允许商业使用' }
  },
  'ai-training': {
    'prohibited': {}  // 无特定冲突
  },
  'expires': {
    'never': {}  // 无特定冲突
  }
};

/**
 * 检查许可证冲突
 * @param newLicense 新添加的许可证
 * @param currentLicenses 当前已选择的许可证
 * @returns 冲突信息对象
 */
export function checkLicenseConflicts(newLicense: string, currentLicenses: string[]): LicenseConflict {
  const conflicts: LicenseConflict = {
    hasConflict: false,
    conflictingLicenses: [],
    reason: '',
    suggestions: []
  };
  
  // 检查互斥规则
  if (INCOMPATIBLE_RULES[newLicense]) {
    const incompatibleLicenses = INCOMPATIBLE_RULES[newLicense];
    const conflicting = currentLicenses.filter(license => incompatibleLicenses.includes(license));
    
    if (conflicting.length > 0) {
      conflicts.hasConflict = true;
      conflicts.conflictingLicenses = conflicting;
      
      // 生成冲突原因和建议
      if (newLicense === 'open') {
        conflicts.reason = '开放使用（完全免费无限制）与其他许可证类型互斥，不能同时选择';
        conflicts.suggestions = ['您可以移除所有其他许可证，仅保留开放使用许可'];
      } else if (currentLicenses.includes('open')) {
        conflicts.reason = '其他许可证类型与开放使用（完全免费无限制）互斥，不能同时选择';
        conflicts.suggestions = [
          '您可以移除开放使用许可证，然后添加其他许可证',
          '或者保留开放使用许可证，不添加其他许可证'
        ];
      } else if (conflicting.includes('non-commercial') && (newLicense === 'commercial' || newLicense === 'commercial-remix')) {
        conflicts.reason = '商业许可证与非商业许可证互斥，不能同时选择';
        conflicts.suggestions = [
          '您可以移除非商业许可证，使用商业许可证',
          '或者使用自定义许可证设置更精细的权限'
        ];
      } else if (newLicense === 'non-commercial' && (currentLicenses.includes('commercial') || currentLicenses.includes('commercial-remix'))) {
        conflicts.reason = '非商业许可证与商业许可证互斥，不能同时选择';
        conflicts.suggestions = [
          '您可以移除商业许可证，使用非商业许可证',
          '或者使用自定义许可证设置更精细的权限'
        ];
      }
    }
  }
  
  return conflicts;
}

/**
 * 检查选项与已选择许可证的冲突
 * @param filterId 过滤器ID
 * @param value 选项值
 * @param selectedLicenses 已选择的许可证
 * @returns 冲突信息
 */
export function checkOptionConflicts(filterId: string, value: string, selectedLicenses: string[]): LicenseConflict {
  const conflicts: LicenseConflict = {
    hasConflict: false,
    conflictingLicenses: [],
    reason: '',
    suggestions: []
  };
  
  // 检查每个选项与已有许可证的冲突
  if (OPTION_CONFLICTS[filterId] && OPTION_CONFLICTS[filterId][value]) {
    const optionConflicts = OPTION_CONFLICTS[filterId][value];
    
    for (const license of selectedLicenses) {
      if (optionConflicts[license]) {
        conflicts.hasConflict = true;
        conflicts.conflictingLicenses.push(license);
        conflicts.reason = optionConflicts[license];
        
        // 添加建议
        if (filterId === 'attribution' && value === 'required') {
          conflicts.suggestions = [
            '您可以移除开放使用许可证以要求归属',
            '或者不要求归属以保持开放使用许可证'
          ];
        } else if (filterId === 'remixing' && value === 'prohibited') {
          conflicts.suggestions = [
            '您可以移除冲突的许可证以禁止混音',
            '或者允许混音以保持现有许可证'
          ];
        } else if (filterId === 'commercial-use') {
          if (value === 'prohibited') {
            conflicts.suggestions = [
              '您可以移除商业许可证以禁止商业使用',
              '或者允许商业使用以保持商业许可证'
            ];
          } else if (value === 'allowed') {
            conflicts.suggestions = [
              '您可以移除非商业许可证以允许商业使用',
              '或者禁止商业使用以保持非商业许可证'
            ];
          }
        }
      }
    }
  }
  
  return conflicts;
}

/**
 * 根据自定义选项生成建议的预设许可证
 * @param filterSelections 当前过滤器选择
 * @returns 建议的预设许可证列表
 */
export function suggestPresetLicenses(filterSelections: Record<string, string | null>): string[] {
  const suggestions: string[] = [];
  
  // 分析自定义设置
  const isCommercial = filterSelections['commercial-use'] === 'allowed';
  const allowsRemix = filterSelections['remixing'] === 'allowed';
  const requiresAttribution = filterSelections['attribution'] === 'required';
  
  // 根据设置建议预设许可证
  if (!isCommercial && allowsRemix) {
    suggestions.push('non-commercial');
  }
  
  if (isCommercial && !allowsRemix) {
    suggestions.push('commercial');
  }
  
  if (isCommercial && allowsRemix) {
    suggestions.push('commercial-remix');
  }
  
  if (!requiresAttribution && isCommercial && allowsRemix && filterSelections['ai-training'] !== 'prohibited') {
    suggestions.push('open');
  }
  
  return suggestions;
}

/**
 * 获取许可证名称
 * @param license 许可证ID
 * @returns 许可证名称
 */
export function getLicenseName(license: string): string {
  const licenseNames: Record<string, string> = {
    'open': '开放使用',
    'non-commercial': '非商业混音',
    'commercial': '商业使用',
    'commercial-remix': '商业混音',
    'custom': '自定义许可证'
  };
  
  return licenseNames[license] || license;
}

/**
 * 从预设许可证创建自定义过滤器选择
 * @param licenseType 许可证类型
 * @returns 过滤器选择
 */
export function createFiltersFromLicense(licenseType: string): Record<string, string | null> {
  const filterSelections: Record<string, string | null> = {
    'ai-training': null,
    'commercial-use': null,
    'attribution': null,
    'remixing': null,
    'licensing-fee': null,
    'expires': null
  };
  
  switch (licenseType) {
    case 'open':
      filterSelections['ai-training'] = 'allowed';
      filterSelections['commercial-use'] = 'allowed';
      filterSelections['attribution'] = 'not-required';
      filterSelections['remixing'] = 'allowed';
      filterSelections['licensing-fee'] = 'free';
      filterSelections['expires'] = 'never';
      break;
      
    case 'non-commercial':
      filterSelections['ai-training'] = 'allowed';
      filterSelections['commercial-use'] = 'prohibited';
      filterSelections['attribution'] = 'required';
      filterSelections['remixing'] = 'allowed';
      filterSelections['licensing-fee'] = 'free';
      break;
      
    case 'commercial':
      filterSelections['ai-training'] = 'allowed';
      filterSelections['commercial-use'] = 'allowed';
      filterSelections['attribution'] = 'required';
      filterSelections['remixing'] = 'prohibited';
      break;
      
    case 'commercial-remix':
      filterSelections['ai-training'] = 'allowed';
      filterSelections['commercial-use'] = 'allowed';
      filterSelections['attribution'] = 'required';
      filterSelections['remixing'] = 'allowed';
      break;
  }
  
  return filterSelections;
}

export default {
  checkLicenseConflicts,
  checkOptionConflicts,
  suggestPresetLicenses,
  getLicenseName,
  createFiltersFromLicense
}; 