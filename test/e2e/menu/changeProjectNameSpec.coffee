describe 'GENius', ->

  describe 'menu', ->

    beforeEach ->
      browser.driver.sleep(500)
      browser.waitForAngular()

    # This test verifies that there is a default title and that
    # the user is able to change the name of the current project
    it 'should allow users to change the project name', ->
      $projectName = element(findBy.id('title'))
      expect($projectName.getAttribute('value')).toEqual('New Biobrick #1')
      $projectName.clear()
      expect($projectName.getAttribute('value')).toEqual('')
      $projectName.sendKeys('New Project Name')
      expect($projectName.getAttribute('value')).toEqual('New Project Name')

