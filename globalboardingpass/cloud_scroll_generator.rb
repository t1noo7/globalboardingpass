require_relative "./cloud_types"

class CloudScrollGenerator
  INITIAL_COUNT = 3
  SHUFFLECLOUD = 'shuffle'

  def initialize(octokit:)
    @octokit = octokit
  end

  def generate
    current_contributors = Hash.new(0)
    current_words_added = INITIAL_COUNT

    octokit.issues.each do |issue|
      if issue.title.split('|')[1] != SHUFFLECLOUD && issue.labels.any? { |label| CloudTypes::CLOUDLABELS.include?(label.name) }
        if issue.labels.any? { |label| label.name == CloudTypes::CLOUDLABELS[-2] }
          current_words_added += 1
          current_contributors[issue.user.login] += 1
        end
      end
    end

    markdown = <<~HTML
      <br/>
      <br/>
      <div align="center">

        ## #{CloudTypes::CLOUDPROMPTS[-2]}

        <img src="#{previous_cloud_url}" alt="GlobalBoardingPass" width="100%">

        ![Passes Badge](https://img.shields.io/badge/Boarding%20Passes%20in%20this%20Global-#{current_words_added}-informational?labelColor=7D898B)
        ![Contributors Badge](https://img.shields.io/badge/Contributors%20in%20this%20Global-#{current_contributors.size}-blueviolet?labelColor=7D898B)


    HTML

    current_contributors.each do |username, count|
      markdown.concat("[![Github Badge](https://img.shields.io/badge/-@#{format_username(username)}-24292e?style=flat&logo=Github&logoColor=white&link=https://github.com/#{username})](https://github.com/#{username}) ")
    end

    markdown.concat("<br/> <br/>  Completed #{DateTime.now.strftime('%B %-d %Y')}")
    markdown.concat("</div>")

  end

  private

  def format_username(name)
    name.gsub('-', '--')
  end

  def previous_cloud_url
    "https://github.com/t1noo7/globalboardingpass/blob/main/previous_globalpasses/#{CloudTypes::CLOUDLABELS[-2]}_cloud#{CloudTypes::CLOUDLABELS.size - 1}.png"
  end

  attr_reader :octokit
end
