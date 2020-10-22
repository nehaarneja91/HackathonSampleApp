import Danger

let danger = Danger()
SwiftLint.lint(inline: true)

// Pull out the edited files and find ones that come from a sub-folder
// where our app lives
let editedFiles = danger.git.modifiedFiles + danger.git.createdFiles
//let editedAppFiles = editedFiles.filter { $0.contains("/App") }

// Let people bail from the CHANGELOG check
let hasSkipChangelog = danger.github.pullRequest.body?.contains("#no_changelog") ?? false
let hasSkipChangelogLabel = danger.github.issue.labels.first { $0.name == "Skip Changelog" }
let skipCheck = hasSkipChangelog || (hasSkipChangelogLabel != nil)

// Request for a CHANGELOG entry with each app change
if editedFiles.count > 0 && !skipCheck {
  fail("Please add a CHANGELOG entry for these changes. If you would like to skip this check, add `#no_changelog` to the PR body and re-run CI.")
}


let hasTicketID = danger.github.pullRequest.title.contains("AM") ?? false
if hasTicketID {
    fail("I couldn't find the ticket ID! Did you forget to add it?")
}

markdown("![Alt iphone](https://s3.ap-southeast-1.amazonaws.com/images.deccanchronicle.com/dc-Cover-3e2ftda9jabdn5q9ffti1emnc3-20170929123140.Medi.jpeg)")
