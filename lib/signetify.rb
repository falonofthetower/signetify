require "signetify/version"

module Signetify
  class Client
    attr_reader :response, :error_message
    attr_accessor :client

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.authorize(token)
      client.refresh_token = token
      client.grant_type = "refresh_token"
      client.fetch_access_token!

      new(response: client)
    rescue Signet::AuthorizationError => e
      new(error_message: e.message)
    end

    def self.client
      @client ||= fresh_client
    end

    def self.client_options
      template = ERB.new File.new("#{Rails.root}/config/signetify.yml").read
      YAML.load template.result(binding)
    end

    def self.fresh_client
      Signet::OAuth2::Client.new(client_options)
    end

    def successful?
      response.present?
    end
  end
end
