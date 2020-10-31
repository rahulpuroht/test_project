  require 'google/api_client'
  require 'date'
  require 'yaml'


  class GA

    def initialize(trackcode)
            @client = Google::APIClient.new()

        ## Load our credentials for the service account
        key_file = File.join('config', SITEMAN_CONFIG['siteman']['key_file'])
        key = Google::APIClient::KeyUtils.load_from_pkcs12(key_file, SITEMAN_CONFIG['siteman']['key_secret'])

        @client.authorization = Signet::OAuth2::Client.new(
          :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
          :audience => 'https://accounts.google.com/o/oauth2/token',
          :scope => 'https://www.googleapis.com/auth/analytics.readonly',
          #:scope => 'https://www.googleapis.com/auth/webmasters.readonly',
          :issuer => SITEMAN_CONFIG['siteman']['service_account_email'],
          :signing_key => key)

         ## Request a token for our service account
        @client.authorization.fetch_access_token!
        @analytics = @client.discovered_api('analytics', 'v3')
        @profile_id = self.getProfileId(trackcode)
        
    end

    def visitors(start_date, end_date)
      if @profile_id
        results = @client.execute(:api_method => @analytics.data.ga.get, :parameters => {
          'ids'         => "ga:" + @profile_id,
          'start-date'  => start_date.to_s,
          'end-date'    => end_date.to_s,
          'metrics'     => "ga:users,ga:pageViews, ga:sessions, #{SITEMAN_CONFIG['siteman']['subscription_goal']}",
          #'dimensions'  => "ga:year,ga:month,ga:day",
          #'sort'        => "ga:year,ga:month,ga:day"
        })
        if results.error?
          puts results.error_message
          return []
        else      
          return results.data.rows
        end
      else 
          return []
      end
    end


end
