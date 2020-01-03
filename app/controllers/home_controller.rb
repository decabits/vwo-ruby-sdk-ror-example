class HomeController < ApplicationController
  USERS = %w(Ashley Bill Chris Dominic Emma Faizan Gimmy Harry Ian John King Lisa Mona Nina Olivia Pete Queen Robert Sarah Tierra Una Varun Will Xin You Zeba)

  def index;end

  def basic_example
    vwo_client_instance = VWOService.get_vwo_instance
    run_example(vwo_client_instance)
  end

  def user_defined_logger_example
    vwo_client_instance = VWOService.get_vwo_instance
    VWOService.start_logger
    run_example(vwo_client_instance)
    VWOService.stop_logger
  end

  def ab
    user_id = params['userId'] || USERS.sample
    vwo_client_instance = VWOService.get_vwo_instance
    variation_name = vwo_client_instance.activate(AbCampaignData['campaign_key'], user_id, { custom_variables: AbCampaignData['custom_variables'] })
    is_part_of_campaign = variation_name.present?
    vwo_client_instance.track(AbCampaignData['campaign_key'], user_id, AbCampaignData['campaign_goal_identifier'], { revenue_value: AbCampaignData['revenue_value'] })

    render :ab, locals: {
      user_id: user_id,
      campaign_type: "Visual-AB",
      is_part_of_campaign: is_part_of_campaign,
      variation_name: variation_name,
      ab_campaign_key: AbCampaignData['campaign_key'],
      ab_campaign_goal_identifier: AbCampaignData['campaign_goal_identifier'],
      custom_variables: JSON.generate(AbCampaignData['custom_variables']),
      settings_file: vwo_client_instance.get_settings
    }
  end

  def feature_rollout_campaign
    user_id = params['userId'] || FeatureRolloutData['user_id'] || USERS.sample
    vwo_client_instance = VWOService.get_vwo_instance
    is_user_part_of_feature_rollout_campaign = vwo_client_instance.feature_enabled?(FeatureRolloutData['campaign_key'], user_id, { custom_variables: FeatureRolloutData['custom_variables'] })

    render 'feature-rollout', locals: {
      user_id: user_id,
      campaign_type: 'Feature-rollout',
      is_user_part_of_feature_rollout_campaign: is_user_part_of_feature_rollout_campaign,
      feature_rollout_campaign_key: FeatureRolloutData['campaign_key'],
      custom_variables: JSON.generate(FeatureRolloutData['custom_variables']),
      settings_file: vwo_client_instance.get_settings
    }
  end

  def feature_campaign
    user_id = params['userId'] || FeatureTestData['user_id'] || USERS.sample
    vwo_client_instance = VWOService.get_vwo_instance
    is_user_part_of_feature_campaign = vwo_client_instance.feature_enabled?(FeatureTestData['campaign_key'], user_id)
    vwo_client_instance.track(
      FeatureTestData['campaign_key'],
      user_id,
      FeatureTestData['campaign_goal_identifier'],
      revenue_value=FeatureTestData['revenue_value'],
      custom_variables=FeatureTestData['custom_variables']
    )
    string_variable = vwo_client_instance.get_feature_variable_value(FeatureTestData['campaign_key'], FeatureTestData['string_variable_key'], user_id, { custom_variables: FeatureTestData['custom_variables'] })
    integer_variable = vwo_client_instance.get_feature_variable_value(FeatureTestData['campaign_key'], FeatureTestData['integer_variable_key'], user_id, { custom_variables: FeatureTestData['custom_variables'] })
    boolean_variable = vwo_client_instance.get_feature_variable_value(FeatureTestData['campaign_key'], FeatureTestData['boolean_variable_key'], user_id, { custom_variables: FeatureTestData['custom_variables'] })
    double_variable = vwo_client_instance.get_feature_variable_value(FeatureTestData['campaign_key'], FeatureTestData['double_variable_key'], user_id, { custom_variables: FeatureTestData['custom_variables'] })

    render 'feature-test', locals: {
      user_id: user_id,
      campaign_type: "Feature-test",
      is_user_part_of_feature_campaign: is_user_part_of_feature_campaign,
      feature_campaign_key: FeatureTestData['campaign_key'],
      feature_campaign_goal_identifier:  FeatureTestData['campaign_goal_identifier'],
      string_variable: string_variable,
      integer_variable: integer_variable,
      boolean_variable: boolean_variable,
      double_variable: double_variable,
      custom_variables: JSON.generate(FeatureRolloutData['custom_variables']),
      settings_file: vwo_client_instance.get_settings
    }
  end


  def push_api
    user_id = params['userId'] || USERS.sample
    vwo_client_instance = VWOService.get_vwo_instance
    result = vwo_client_instance.push(PushData['tag_key'], PushData['tag_value'], user_id)

    render :push, locals: {
      user_id: user_id,
      tag_key: PushData['tag_key'],
      tag_value: PushData['tag_value'],
      result: result,
      settings_file: vwo_client_instance.get_settings
    }
  end

  def user_storage_example
    vwo_client_instance = VWOService.get_vwo_user_storage_instance
    run_example(vwo_client_instance)
  end

  private

  def run_example(vwo_client_instance)
    ab_campaign_key = params['ab_campaign_key']
    user_id = params['userId'] || USERS.sample
    revenue_value = params['revenue'].to_i
    ab_campaign_goal_identifier = params['ab_campaign_goal_identifier']

    variation_name = vwo_client_instance.activate(ab_campaign_key, user_id)
    vwo_client_instance.track(ab_campaign_key, user_id, ab_campaign_goal_identifier, revenue_value)

    render :example, locals: {
      part_of_campaign: variation_name.nil? ? 'No' : 'Yes',
      variation_name: variation_name,
      settings_file: vwo_client_instance.get_settings,
      ab_campaign_key: ab_campaign_key,
      ab_campaign_goal_identifier: ab_campaign_goal_identifier,
      user_id: user_id
    }
  end
end
