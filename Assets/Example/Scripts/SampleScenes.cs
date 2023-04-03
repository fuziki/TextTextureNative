using UnityEngine;
using UnityEngine.SceneManagement;

public class SampleScenes : MonoBehaviour
{
    public void LoadNativeRenderTextSample()
    {
        SceneManager.LoadScene("NativeRenderTextSample");
    }

    public void LoadVsUIText()
    {
        SceneManager.LoadScene("VsUIText");
    }

    public void LoadMultipleRendering()
    {
        SceneManager.LoadScene("MultipleRendering");
    }
}
