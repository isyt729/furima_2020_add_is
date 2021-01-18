window.addEventListener("load", (e) => {
  if(document.getElementById('item_images')){
  const inputElement = document.getElementById("item-tag");
    inputElement.addEventListener("keyup", (e) => {
      const input = document.getElementById("item-tag").value;

      const xhr = new XMLHttpRequest();
      xhr.open("GET", `tag_search/?input=${input}`, true);
      xhr.responseType = "json";
      xhr.send();

      xhr.onload = () => {
        const searchResult = document.getElementById('search-result')
        searchResult.innerHTML = ''

        if(xhr.response){
          const tagName = xhr.response.keyword

          tagName.forEach(function(tag){
            const parentsElement = document.createElement('div')
            const childElement = document.createElement('div')

            parentsElement.setAttribute('id', 'parents')
            childElement.setAttribute('id', tag.id )
            childElement.setAttribute('class', 'child' )

            parentsElement.appendChild(childElement)
            childElement.innerHTML = tag.tag_name
            searchResult.appendChild(parentsElement)

            const clickElement = document.getElementById(tag.id)
            clickElement.addEventListener("click", () => {
              document.getElementById("item-tag").value = clickElement.textContent;
              clickElement.remove();
            })
          })
        }
      }
    });
  }
})