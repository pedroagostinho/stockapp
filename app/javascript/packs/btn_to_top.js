// When the user scrolls down 500px from the top of the document, show the button
const scrollFunction = () => {
  if (document.body.scrollTop > 1000 || document.documentElement.scrollTop > 1000) {
    document.getElementById("btnToTop").style.display = "block";
    const joinBeta = document.querySelectorAll(".btnToBeta2")
    joinBeta.forEach((btn) => {
      btn.style.opacity = 1;
    });
  } else {
    document.getElementById("btnToTop").style.display = "none";
    const joinBeta = document.querySelectorAll(".btnToBeta2")
    joinBeta.forEach((btn) => {
      btn.style.opacity = 0;
    });
  }
}

// When the user clicks on the button, scroll to the top of the document
const topFunction = () => {
  // $(document).ready(function(){
    // $('#btnToTop').click(function(){
      $("html, body").animate({ scrollTop: 0 }, 500);
    // });
  // });

}

export { scrollFunction, topFunction };
