require 'sinatra'
require 'httparty'

get '/slow_response' do
  start_time = Time.now

  token = ENV["GITHUB_API_TOKEN"]
  repos = JSON.parse(IO.read("data/repos.json"))
  res = []

  repos.each do |repo|
    owner, repo = repo.split("/")

    response = HTTParty.get(
      "https://api.github.com/repos/#{owner}/#{repo}",
      headers: {
        "Authorization" => "Bearer #{token}",
        "User-Agent" => "sunny-b"
      }
    )
    data = JSON.parse(response.body)

    repo_data = {
      owner: owner,
      repository: repo,
      stars: data["stargazers_count"],
      forks: data["forks_count"],
      watchers: data["watchers_count"],
      language: data["language"]
    }

    res << repo_data
  end

  end_time = Time.now

  JSON.generate({
    response: res,
    time: end_time.to_f - start_time.to_f
  })
end

get '/fast_response' do
  start_time = Time.now

  token = ENV["GITHUB_API_TOKEN"]
  repos = JSON.parse(IO.read("data/repos.json"))
  res = []
  threads = []
  mutex = Mutex.new

  repos.each do |repo|
    threads << Thread.new do
      owner, repo = repo.split("/")

      response = HTTParty.get(
        "https://api.github.com/repos/#{owner}/#{repo}",
        headers: {
          "Authorization" => "Bearer #{token}",
          "User-Agent" => "sunny-b"
        }
      )
      data = JSON.parse(response.body)

      repo_data = {
        owner: owner,
        repository: repo,
        stars: data["stargazers_count"],
        forks: data["forks_count"],
        watchers: data["watchers_count"],
        language: data["language"]
      }

      mutex.synchronize { res << repo_data }
    end
  end

  threads.each(&:join)

  JSON.generate({
    response: res,
    time: Time.now.to_f - start_time.to_f
  })
end

get '/faster_response' do
  start_time = Time.now

  token = ENV["GITHUB_API_TOKEN"]
  repos = JSON.parse(IO.read("data/repos.json"))

  # array of threads
  res = repos.map do |repo|
    Thread.new do
      owner, repo = repo.split("/")

      response = HTTParty.get(
        "https://api.github.com/repos/#{owner}/#{repo}",
        headers: {
          "Authorization" => "Bearer #{token}",
          "User-Agent" => "sunny-b"
        }
      )
      data = JSON.parse(response.body)

      {
        owner: owner,
        repository: repo,
        stars: data["stargazers_count"],
        forks: data["forks_count"],
        watchers: data["watchers_count"],
        language: data["language"]
      }
    end
  end

  JSON.generate({
    response: res.map(&:value),
    time: Time.now.to_f - start_time.to_f
  })
end
