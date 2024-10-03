# require_relative "./cloud_types"

class ReadmeGenerator
  WORD_CLOUD_URL = 'https://raw.githubusercontent.com/t1noo7/globalboardingpass/main/globalboardingpass/wordcloud.png'
  ADDWORD = 'add'
  SHUFFLECLOUD = 'shuffle'
  INITIAL_COUNT = 0
  USER = "t1noo7"

  def initialize(octokit:)
    @octokit = octokit
  end

  def generate
    participants = Hash.new(0)
    current_contributors = Hash.new(0)
    current_words_added = INITIAL_COUNT
    total_clouds = CloudTypes::CLOUDLABELS.length
    total_words_added = INITIAL_COUNT * total_clouds

    octokit.issues.each do |issue|
      participants[issue.user.login] += 1
      if issue.title.split('|')[1] != SHUFFLECLOUD && issue.labels.any? { |label| CloudTypes::CLOUDLABELS.include?(label.name) }
        total_words_added += 1
        if issue.labels.any? { |label| label.name == CloudTypes::CLOUDLABELS.last }
          current_words_added += 1
          current_contributors[issue.user.login] += 1
        end
      end
    end

    markdown = <<~HTML
<h3>
  
[<b>⊲◅◁ Hellsaway( ͜ₒ ㅅ ͜ ₒ)ʰᵘʰ ✧˚ ༘ ⋆｡♡˚ς(＾◡＾ ) </b>](https://github.com/t1noo7/t1noo7)    
#
<!--✏️WORDBOARD --> 
<h2 align="center">
Join the Global Boarding Pass ૮₍ ˶ᵔ ᵕ ᵔ˶ ₎ა

### :thought_balloon: [Add your name](https://github.com/t1noo7/globalboardingpass/issues/new?template=addword.md&title=globalpass%7Cadd%7C%3CINSERT-WORD%3E) to see your teleport in real time 𖦹.𖥔 ݁ ˖

:star2: Don't like the arrangement? [Regenerate it](https://github.com/t1noo7/globalboardingpass/issues/new?template=shufflecloud.md&title=globalpass%7Cshuffle) :game_die:

<div align="center">

## Global Boarding Pass 🖍️🫠

![Word Cloud Words Badge](https://img.shields.io/badge/Boarding%20Pass%20in%20this%20Global-126-informational?labelColor=003995)
![Word Cloud Contributors Badge](https://img.shields.io/badge/Cloud%20Contributors-110-blueviolet?labelColor=25004e)

<img src="https://raw.githubusercontent.com/t1noo7/globalboardingpass/main/globalboardingpass/wordcloud.png" alt="GlobalBoardingPass" width="100%">
</div>

[![Github Badge](https://img.shields.io/badge/-@Satyajit--Chaudhuri-24292e?style=flat&logo=Github&logoColor=white&link=https://github.com/Satyajit-Chaudhuri)](https://github.com/Satyajit-Chaudhuri)

   HTML
    # TODO: [![Github Badge](https://img.shields.io/badge/-@username-24292e?style=flat&logo=Github&logoColor=white&link=https://github.com/username)](https://github.com/username)

    current_contributors.each do |username, count|
    end

    markdown.concat()

  end

  private

  def format_username(name)
    name.gsub('-', '--')
  end

  def previous_cloud_url
    url_end = CloudTypes::CLOUDPROMPTS[-2].gsub(' ', '-').gsub(':', '').gsub('?', '').downcase
    "previous_globalpasses/previous_globalpasses.md##{url_end}"
  end

  attr_reader :octokit
end
