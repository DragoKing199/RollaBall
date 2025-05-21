using UnityEngine;
using UnityEngine.UI;

public class HideObject : MonoBehaviour
{
    // Assign the button in the inspector
    public Button yourButton;
    // Specify the tag of the object you want to hide
    public string tagToFind = "Door 1";
    void Start()
    {
        // Make sure the button is assigned
        if (yourButton != null)
        {
            // Add a listener to the button that calls HideObjects function when clicked
            yourButton.onClick.AddListener(HideObjects);
        }
    }

    // Function to hide objects with the specified tag
    void HideObjects()
    {
        // Find all objects with the specified tag
        GameObject[] objectsToHide = GameObject.FindGameObjectsWithTag(tagToFind);

        // Loop through each object and disable it
        foreach (GameObject obj in objectsToHide)
        {
            obj.SetActive(false); // Disables the object (makes it disappear)
        }
    }
}
