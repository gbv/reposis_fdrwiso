
$(document).ready(function() {

  // spam protection for mails
  $('span.madress').each(function(i) {
      var text = $(this).text();
      var address = text.replace(" [at] ", "@");
      $(this).after('<a href="mailto:'+address+'">'+ address +'</a>')
      $(this).remove();
  });

  // activate empty search on start page
  $("#project-searchMainPage").submit(function (evt) {
    $(this).find(":input").filter(function () {
          return !this.value;
      }).attr("disabled", true);
    return true;
  });

  // replace placeholder USERNAME with username
  var userID = $("#currentUser strong").html();
  var newHref = 'https://reposis-test.gbv.de/PROJECT/servlets/solr/select?q=createdby:' + userID + '&fq=objectType:mods';
  $("a[href='https://reposis-test.gbv.de/PROJECT/servlets/solr/select?q=createdby:USERNAME']").attr('href', newHref);

  // type-ahead for classification
  $(".classification-select").each(function () {
    // setDefault($(this));
     if ($(this).children("option").length >= 0) {
         setLabelForClassification($(this));
     }
     else {
         setSelect2Classification($(this));
     }
  });

});

// TODO: Parameterize the select function in MIR (type-ahead)
function setLabelForClassification(parent) {
  $.ajax({
      url: webApplicationBaseURL + 'servlets/solr/select',
      data: {
              q: optionsToQuery(parent),
              fq: 'classification:jel',
              wt: 'json',
              core: 'classification'
      },
      dataType: 'json'
  }).done(function(data) {
      $.each(data.response.docs, function (_i, cat) {
          let text = cat['label.' + $("html").attr("lang")][0];
          if (text === undefined) {
              text = cat['label.en'][0]
          }
          getOptionWithValClassification(parent, cat.category).html(text);
      });
      setSelect2Classification(parent);
  });
}

function optionsToQuery(elm) {
  let query = [];
  $(elm).children().each(function (i, option) {
      if ($(option).val() !== "") {
          query.push('category:' + $(option).val());
      }
  });
  return query.join(" OR ");
}

function setSelect2Classification(elm) {
  $(elm).select2({
      ajax: {
          url: webApplicationBaseURL + 'servlets/solr/select',
          data: function (params) {
              params.term = (params.term == null) ? "" : params.term;
              return {
                  q: '-id:jel OR category *' + params.term.replace(/\./g, "_") + "* OR " + 'label.en *' + params.term + "* OR " + 'label.de *' + params.term + "*",
                  fq: 'classification:jel',
                  rows: 2147483647,
                  sort: 'category ASC',
                  wt: 'json',
                  core: 'classification'
              };
          },
          dataType: 'json',
          processResults: function (data) {
              let res = {
                  results: $.map(data.response.docs, function(obj) {
                      let text = obj['label.' + $("html").attr("lang")];
                      if (text === undefined) {
                          text = obj['label.en'][0]
                      }
                      else {
                          text = text[0];
                      }
                      return { id: obj.category, text: text };
                  })
              };
              addDefault(elm, res);
              return res;
          },
      },
      minimumInputLength: 0,
      language: $("html").attr("lang")
  });
}

function addDefault(elm, res) {
  $(elm).children().each(function (i, option) {
      let found = false;
      $.each(res.results, function (i, solrOption) {
          if (solrOption.id === $(option).val()) {
              found = true;
              return false;
          }
      });
      if (!found) {
          if ($(option).val() !== "") {
              res.results.push({id: $(option).val(), text: $(option).html()})
          }
      }
  })
}

function getOptionWithValClassification(elm, val) {
  return $(elm).find("option[value='" + val + "']");
}
