# Stubs OpenAI client calls for E2E testing without an API key.
# Activate by setting STUB_OPENAI=1 in the environment.
# Skipped in production regardless.
return if Rails.env.production?
return unless ENV['STUB_OPENAI'] == '1'

Rails.application.config.after_initialize do
  Rails.logger.warn '[openai_stub] OpenAI::Client is stubbed — no real API calls will be made'

  OpenAI::Client.class_eval do
    def chat(parameters:)
      messages = parameters[:messages] || []
      user_msg = messages.reverse.find { |m| m[:role] == 'user' || m['role'] == 'user' }
      user_text = user_msg ? (user_msg[:content] || user_msg['content']).to_s : ''

      reply = if user_text.match?(/在留|residence card|visa|ビザ|भिसा|निवास/i)
                "Stub: To renew your residence card, apply at your local Immigration Bureau up to 3 months before expiry. Bring your passport, current residence card, photo, and the application form."
              elsif user_text.match?(/health|保険|insurance|स्वास्थ्य/i)
                "Stub: Japan has two main systems — National Health Insurance (NHI / 国民健康保険) for self-employed and Shakai Hoken (社会保険) for company employees."
              elsif user_text.match?(/tax|税|कर/i)
                "Stub: Tax filing season runs mid-Feb to mid-March. If your employer does nenmatsu chosei (年末調整), you may not need to file separately."
              elsif user_text.match?(/bank|銀行|बैंक/i)
                "Stub: To open a Japanese bank account, bring your residence card, hanko (or signature at some banks), and proof of address."
              else
                "Stub response from JapanBuddy AI: I received your question — \"#{user_text[0, 80]}\". (Real OpenAI calls disabled in this test environment.)"
              end

      if parameters[:stream]
        # Simulate token-by-token streaming
        reply.scan(/.{1,8}/m).each do |chunk_text|
          parameters[:stream].call({ 'choices' => [{ 'delta' => { 'content' => chunk_text } }] }, chunk_text.bytesize)
        end
        { 'choices' => [{ 'message' => { 'content' => reply } }] }
      else
        { 'choices' => [{ 'message' => { 'content' => reply } }] }
      end
    end

    def embeddings(parameters:)
      input = parameters[:input].to_s
      # Deterministic pseudo-embedding so similarity is stable
      seed = input.bytes.sum
      vec = Array.new(8) { |i| Math.sin((seed + i) * 0.13).round(4) }
      { 'data' => [{ 'embedding' => vec }] }
    end
  end
end
