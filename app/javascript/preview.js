
document.addEventListener('DOMContentLoaded', function(){
  if(document.getElementById('item_images')){
    //画像が選択された時のイベント
    const uploadEvent = (e) => {
      const file = e.target.files[0];
      const index = e.target.dataset.index

      if(file){
        blob = window.URL.createObjectURL(file);
        createImageHTML(blob,index);
      }
      //画像編集の時、何も選択されていない場合はinputを削除する
      else{
        document.querySelectorAll(`[data-index="${edit_num}"]`)[0].remove();
        let fields = document.getElementsByClassName('item_images');

        if ( fields.length > 1){   
          fields[fields.length-1].remove();
        }
      }
    }
    //編集ボタンイベント
    const editEvent = (ImageEdit) => {
      ImageEdit.addEventListener('click', (e) => {
      e.preventDefault();
      edit_ele = e.target.parentNode;
      edit_num = edit_ele.dataset.index;
      document.querySelectorAll(`[data-index="${edit_num}"]`)[1].click();
      });
    }
    //削除ボタンイベント
    const deleteEvent = (ImageDelete) => {
      ImageDelete.addEventListener('click', (e) => {
        e.preventDefault();
        delete_ele = e.target.parentNode
        delete_num = delete_ele.dataset.index;
        delete_ele.remove();

        if ( document.getElementsByClassName('item_images').length > 1){
          document.querySelectorAll(`[data-index="${delete_num}"]`)[0].remove();
        }
        else{
          document.querySelectorAll(`[data-index="${delete_num}"]`)[0].value = ""; 
        }
      });
    }

    //プレビュー画像の生成・追加
    const addImage = (blob,imageElement) => {
      const blobImage = document.createElement('img');
      blobImage.setAttribute('class', 'pre_img')
      blobImage.setAttribute('src', blob);
      imageElement.appendChild(blobImage);
    }

    // 画像の削除ボタン生成・追加
    const addDeleteBtn = (imageElement) => {
      const ImageDelete = document.createElement('button');
      ImageDelete.setAttribute('class', `images-delete`)
      ImageDelete.innerText ="削除"
      imageElement.appendChild(ImageDelete);
      //イベントリスナーの追加
      deleteEvent(ImageDelete);
    }

    //画像の編集ボタン生成・追加
    const addEditBtn = (imageElement) => {
      const ImageEdit = document.createElement('button');
      ImageEdit.setAttribute('class', `images-edit`)
      ImageEdit.innerText ="編集"
      imageElement.appendChild(ImageEdit);
      //イベントリスナーの追加
      editEvent(ImageEdit);
    }

    //画像編集時の画像削除
    const aleadyImageDelete = (index) => {
      pre_image = document.querySelectorAll(`#image-list [data-index="${index}"]`)[0];
      if(pre_image){
        pre_image.remove();
      }
    }

    //ファイルフィールドの生成・追加
    const addField = (index) => {
      const flieuploader = document.getElementsByClassName('click-upload')[0];

      const inputHTML = document.createElement('input');
      inputHTML.setAttribute('class', 'item_images');
      inputHTML.setAttribute('name', 'item[images][]');
      inputHTML.setAttribute('type', 'file');
      inputHTML.dataset.index = parseInt(index)+1;

      flieuploader.appendChild(inputHTML);

      //イベントリスナーの追加
      inputHTML.addEventListener('change', (e) => {
        uploadEvent(e);
      })
    }

    //HTMLの生成・追加
    const createImageHTML = (blob,index) => {
      const imageList = document.getElementById('image-list');
      
      // 画像を表示するためのdiv要素を生成
      const imageElement = document.createElement('div');
      imageElement.setAttribute('class', `pre-images`);
      imageElement.dataset.index = index;
      
      //画像編集時に既に画像があったら削除する
      aleadyImageDelete(index);
        // 生成したHTMLの要素をブラウザに表示させる
      addImage(blob, imageElement);
      //画像の編集ボタン
      addEditBtn(imageElement);
      //画像の削除ボタン
      addDeleteBtn(imageElement);
      //画像、編集ボタン、削除ボタンのHTMLへの追加
      imageList.appendChild(imageElement);
      //画像フィールドの追加
      addField(index)
    };

    //ビューファイルのファイルフィールドのイベントリスナー
    document.getElementById('item_images').addEventListener('change', function(e){
      uploadEvent(e);
    });

    //「クリックしてファイルをアップロード」で画像選択
    document.getElementById("image-upload").onclick = function(){
      let fields = document.getElementsByClassName('item_images');

      if(document.getElementsByClassName('pre-images').length < 5){
        fields[fields.length-1].click();
      }  
    }

    //input数のバグ防止
    document.getElementsByClassName("sell-btn")[0].onclick = function(){
      let fields = document.getElementsByClassName('item_images')
      if(fields.length == 6 ){fields[fields.length-1].remove();} 
    }
  }
});



