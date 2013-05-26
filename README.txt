AOOK Ranking

AOOK API-nøkkel: 8c9ffc05a6c44fdc8a26a0daefce4bfa

 curl -H "ApiKey:8c9ffc05a6c44fdc8a26a0daefce4bfa" --insecure "https://eventor.orientering.no/api/organisation/apiKey" | xmllint.exe --format -


curl -H "ApiKey:8c9ffc05a6c44fdc8a26a0daefce4bfa" --insecure \
"https://eventor.orientering.no/api/results/event?eventId=2007" | xmllint \
--format - > data/nydalten-2013.xml


mvn archetype:generate \
      -DarchetypeGroupId=org.scala-tools.archetypes \
      -DarchetypeArtifactId=scala-archetype-simple  \
      -DremoteRepositories=http://scala-tools.org/repo-releases \
      -DgroupId=net.spjelkavik.aook \
      -DartifactId=RankingImporter \
      -Dversion=1.0-SNAPSHOT



// curl -H "ApiKey:8c9ffc05a6c44fdc8a26a0daefce4bfa" --insecure "https://eventor.orientering.no/api/results/event?eventId=467" | xmllint.exe --format -  > lk.txt



Web:

- List series
- List races in series
- List results for a race in a series
- List overall standing
