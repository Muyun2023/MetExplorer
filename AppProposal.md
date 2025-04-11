# Submission 1: API Selection

## Selected API
The Metropolitan Museum of Art Collection API  

## Endpoint
[Metropolitan Museum API](https://metmuseum.github.io/)  

## Summary
A Met Explorer that lets users browse museum collections by department, culture, and era, allowing them to create personal digital art galleries for research, themed collections, educational use, visit planning, social sharing, and more.

---

# Submission 2: Design

## Persistence
- Store an array of artwork objectID values locally.
- Re-fetch complete artwork data using stored IDs (via `/objects/{id}` endpoint).

## UI Basic

### Tab 1 - Browse
#### Stack 1A: Department List
- **Data source:** `GET /departments`
- **Displayed fields:** `displayName` (department title)
- **User action:** Select department → Stack 1B

#### Stack 1B: Department Artworks
- **Data source:** `GET /objects?departmentIds={selectedId}`
- **Displayed fields:**
  - `title` (artwork name)
  - `primaryImageSmall` (thumbnail)
  - `artistDisplayName` (artist)
- **User actions:**
  - Search: Client-side filtering by title keywords.
  - Filter: Group target artworks by `culture` field.
  - Tap artwork → Stack 1C

#### Stack 1C: Artwork Detail
- **Data source:** `GET /objects/{selectedObjectID}`
- **Displayed fields:**
  - `primaryImage` (high-res image)
  - `objectDate` (creation period)
  - `title + artistDisplayName` (Title & artist)
  - `medium` (materials)
- **User actions:**
  - **Smart Favorite Button:**
    - **Default State (Not collected):**
      - Button label: "Add to Collection"
      - Single Tap: Launches tag selector
    - **Collected State:**
      - Button shows active tag emoji (e.g., ❤️)
      - Single Tap: Opens tag management panel
  - **Tag Selection Dialog:**
    - Last-used tags appear first
    - "Custom..." opens text input for new tags

### Tab 2 - My Collection
#### Stack 2A: Favorites List
- **Data source:**
  - Locally stored `objectID` array
  - Call `GET /objects/{id}` for each ID to get updated data
- **Displayed fields:**
  - `primaryImageSmall` (thumbnail)
  - `title` (artwork name)
  - `artistDisplayName + objectDate` (secondary text)
  - Active tag emoji (e.g., ❤️) right-aligned
- **User actions:**
  - Pull-to-refresh: Re-fetch all artwork data
  - Tap artwork → Stack 2B (Detail View with edit mode)
  - Swipe left:
    - Delete option (removes `objectID` from local storage)
    - Tag edit option (opens Tag Selection Dialog)

#### Stack 2B: Collection Detail (Edit Mode)
- **Enhanced features vs Stack 1C:**
  - **Tag management bar:**
    - Shows all assigned tags
    - Tap any tag to:
      - Remove from current artwork
      - Filter all artworks with same tag (→ Stack 2C)
  - **Metadata comparison:**
    - "Last updated: [timestamp]" from API response header
  - **Context menu:**
    - "Suggest similar" (uses culture/medium fields)

#### Stack 2C: Tag Filter View
- **Trigger:** Selecting tag in Stack 2A/2B
- **Data flow:**
  - Filter local `objectID` array by tag
  - Call `GET /objects/{id}` for each filtered ID
- **Display:** List view with `primaryImageSmall` + `title`

## Planned Feature
- Share collection via link/image export

---

# Professor Feedback   

## Whole App Design

### General Feedback
- This is an excellent and ambitious design for a very fully featured app! You’ve covered the project requirements completely and beyond. Be sure to focus on the minimum product first, then add further features as you have time.
- Some areas can be consolidated to save time. See notes in "Things to Consider."
- "Things to Save for Last" lists features that should be prioritized last to meet requirements first.

### UI Feedback
#### Tab 1
- **Design:** Great plan for displaying departments, lists of art, and search/filter features. It covers all essential aspects of an app like this.
- **Random Thought:** Are there any other details users might be interested in on the Artwork Detail screen? How would you display it concisely and cleanly?

#### Tab 2
- **Design:** The design is detailed and well thought out. The metadata comparison is particularly valuable—users will appreciate the "last updated" feature, which is often missing in apps.
- **Persistence:** Consider storing some artwork data (e.g., title and small image URL) along with `objectID` to render the list immediately, rather than hitting the backend just to display favorites. Items can be updated when tapped.

### Things to Consider
- **Stack 2B can reuse Stack 1B's structure** (or a similar View component). See where subviews/components can be reused rather than redesigning from scratch.

### Things to Save for Last
- **Tag system:** The Tag Selection Dialog, Tag Filter View, and Smart Favorite Button may be more complex than expected. If the "Add to Collection" concept and Favorites list are implemented first, all core assignment requirements will be met. Additional tagging features can be developed afterward.



## Week1 Feedback
- Avoid using the ObservableObject protocol, @StateObject, and @Published, as they have largely been replaced by simply using @Observable and @State. By making this shift you set yourself up better to work with Swift Data @Model objects.
  
- If you switch to Swift 6 language mode (click your xcodeproj in the navigator -> go to the build settings tab -> search for the Swift Language Version entry, set it to Swift 6) you’ll see there are potential concurrency race conditions that are considered compiler errors by the Swift 6 language mode. To avoid these errors and potential race conditions, consider using async/await instead of dispatch queues and callbacks, which is the older way of doing things that async/await has replaced.
Your error handling is currently primarily either printing to the console or swallowing the error (by returning nil or the like). This is fine for now as you’re just getting started but don’t forget that proper error handling is a requirement for the project.

- So far you’ve got the one screen and one network data model. The screen looks great and loads the data perfectly. That said, you’ll need to move fast to get all of the project requirements done on time (less than 2 weeks left!). You’ve still got a detail page, a tabview with tabs, user interaction, and persistence to complete! Best of luck!
