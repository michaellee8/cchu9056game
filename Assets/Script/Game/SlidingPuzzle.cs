using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using EzySlice;
using UnityEngine;
using Object = UnityEngine.Object;
using Plane = EzySlice.Plane;
using Random = UnityEngine.Random;

namespace Script.Game
{
    public class LocationMeta : Object
    {
        public Vector3Int CurrentLocation;
        private readonly Vector3Int DefaultLocation;

        public LocationMeta(Vector3Int currentLocation, Vector3Int defaultLocation)
        {
            CurrentLocation = currentLocation;
            DefaultLocation = defaultLocation;
        }

        public bool isDefaultLocation()
        {
            return CurrentLocation == DefaultLocation;
        }
    }

    public class SlidingPuzzle : MonoBehaviour
    {

        [SerializeField] private GameObject parentObject;
        [SerializeField] private GameObject mainMesh;
        [SerializeField] private Material crossSectionMaterial;

        private Vector3 _mainMeshScale;

        [SerializeField] private Vector3Int finalDimension;
        private List<GameObject> _slicedMeshes = new List<GameObject>();

        private Vector3Int _emptySpace = Vector3Int.zero;
        private Vector3 _midVertex;

        private IEnumerable<GameObject> Slice(GameObject obj, Vector3 begin, Vector3 step, int count)
        {
            var result = new List<GameObject>();
            var temObj = obj;

            for (var i = 1; i < count; ++i)
            {
                var newObj = temObj.SliceInstantiate(new Plane(begin + step * i, step), new TextureRegion(0.0f, 0.0f, 1.0f, 1.0f), crossSectionMaterial);
                if (newObj == null)
                {
                    print("SliceInstantiate failed");
                    break;
                }

                if (temObj.scene.name != null) Destroy(temObj);

                result.Add(newObj.Last());
                temObj = newObj.First();
            }

            result.Add(temObj);
            return result;
        }

        private List<GameObject> SliceByDimension(GameObject obj, Vector3Int dimension)
        {
            var result = new List<GameObject>
            {
                obj
            };

            for (var i = 0; i < 3; ++i)
            {
                var temList = new List<GameObject>();

                result.ForEach(o =>
                {
                    var meshBound = o.GetComponent<MeshFilter>().sharedMesh.bounds;

                    var begin = Vector3.zero;
                    begin[i] = -meshBound.size[i] / 2;

                    var step = Vector3.zero;
                    step[i] = meshBound.size[i] / dimension[i];

                    if (i == 0)
                    {
                        // avoid infinite normal
                        step.y += 0.001f;
                    }

                    temList.AddRange(Slice(o, begin + meshBound.center, step, dimension[i]));
                });
                result = temList;
            }

            return result;
        }

        private void Start()
        {
            UnityEngine.Cursor.lockState = CursorLockMode.Locked;
            if (!mainMesh.TryGetComponent<MeshFilter>(out _))
            {
                mainMesh = GetComponentInChildren<MeshFilter>().gameObject;
            }

            var meshComp = mainMesh.GetComponent<MeshFilter>().sharedMesh;
            _midVertex = new Vector3(meshComp.vertices.Average(v => v.x), meshComp.vertices.Average(v => v.y), meshComp.vertices.Average(v => v.z));
            // var meshBound = meshComp.bounds;

            var mainObj = mainMesh;
            if (mainObj.scene.name == null) mainObj = Instantiate(mainMesh);
            _mainMeshScale = mainObj.transform.localScale;
            // ResetTransform(mainObj);

            _slicedMeshes = SliceByDimension(mainObj, finalDimension);
            for (var i = 0; i < _slicedMeshes.Count; i++)
            {
                _slicedMeshes[i].AddComponent<GearOnSelect>().data = new LocationMeta(Vector3Int.FloorToInt(IndexToVector(i)), Vector3Int.FloorToInt(IndexToVector(i)));
                _slicedMeshes[i].AddComponent<MeshCollider>().convex = true;
                _slicedMeshes[i].transform.parent = parentObject.transform;
            }
            
            StartCoroutine(StartShuffle());
        }

        private static void ResetTransform(GameObject obj)
        {
            obj.transform.localPosition = Vector3.zero;
            obj.transform.localRotation = Quaternion.identity;
            obj.transform.localScale = Vector3.one;
        }

        private IEnumerator StartShuffle(float delay = 5)
        {
            yield return new WaitForSeconds(delay);

            for (var i = 0; i < _slicedMeshes.Count; i++)
            {
                // var slicedMeshComp = _slicedMeshes[i].GetComponent<MeshFilter>().sharedMesh;
                // var slicedMeshMidVertex = new Vector3(slicedMeshComp.vertices.Average(v => v.x), slicedMeshComp.vertices.Average(v => v.y), slicedMeshComp.vertices.Average(v => v.z));

                var offset = IndexToVector(i);
                offset.Scale(_mainMeshScale);
                StartCoroutine(SmoothLerp(_slicedMeshes[i], offset * 5 - _slicedMeshes[i].transform.position, 1f));
                yield return new WaitForEndOfFrame();
            }

            _emptySpace = Vector3Int.zero;
            _slicedMeshes[0].SetActive(false);

            yield return new WaitForSeconds(2);

            var previousLocation = _emptySpace;
            for (var i = 0; i < 100;)
            {
                var temVec = _emptySpace;

                var index = Random.Range(0, 3);
                var offset = Random.Range(-1, 2);
                temVec[index] += offset;

                if (temVec == previousLocation) continue;

                var temPreviousLocation = _emptySpace;
                if (!Move(temVec.x, temVec.y, temVec.z)) continue;
                previousLocation = temPreviousLocation;

                yield return new WaitForSeconds(0.05f);
                ++i;
            }
        }

        private IEnumerator SmoothLerp(GameObject obj, Vector3 offset, float time)
        {
            var startingPos = obj.transform.position;
            var finalPos = startingPos + offset;

            float elapsedTime = 0;

            while (elapsedTime < time)
            {
                obj.transform.position = Vector3.Lerp(startingPos, finalPos, elapsedTime / time);
                elapsedTime += Time.deltaTime;
                yield return null;
            }

            obj.transform.position = finalPos;
        }

        private int GetObjectIndex(Vector3Int v)
        {
            return GetObjectIndex(v.x, v.y, v.z);
        }

        private int GetObjectIndex(int x, int y, int z)
        {
            return x * finalDimension.z * finalDimension.y + y * finalDimension.z + z;
        }

        private Vector3 IndexToVector(int index)
        {
            var z = index % finalDimension.z;
            index /= finalDimension.z;

            var y = index % finalDimension.y;
            index /= finalDimension.y;

            return new Vector3(index % finalDimension.x, y, z);
        }

        private bool Move(LocationMeta locationMeta)
        {
            return Move(locationMeta.CurrentLocation.x, locationMeta.CurrentLocation.y, locationMeta.CurrentLocation.z);
        }

        private bool Move(int x, int y, int z)
        {
            if (x < 0 || x >= finalDimension.x || y < 0 || y >= finalDimension.y || z < 0 | z >= finalDimension.z)
            {
                return false;
            }

            var targetCoordinate = new Vector3Int(x, y, z);
            if (Math.Abs((targetCoordinate - _emptySpace).magnitude - 1) < float.Epsilon)
            {
                var emptySpaceLocationMeta = _slicedMeshes[GetObjectIndex(_emptySpace)].GetComponent<GearOnSelect>().data as LocationMeta;
                var targetSpaceLocationMeta = _slicedMeshes[GetObjectIndex(targetCoordinate)].GetComponent<GearOnSelect>().data as LocationMeta;
                (emptySpaceLocationMeta.CurrentLocation, targetSpaceLocationMeta.CurrentLocation) = (targetSpaceLocationMeta.CurrentLocation, emptySpaceLocationMeta.CurrentLocation);

                _slicedMeshes[GetObjectIndex(_emptySpace)].transform.position = _slicedMeshes[GetObjectIndex(targetCoordinate)].transform.position;

                Vector3 offset = _emptySpace - targetCoordinate;
                offset.Scale(_mainMeshScale);

                StartCoroutine(SmoothLerp(_slicedMeshes[GetObjectIndex(targetCoordinate)], offset * 10, 0.05f));
                (_slicedMeshes[GetObjectIndex(targetCoordinate)], _slicedMeshes[GetObjectIndex(_emptySpace)])
                    = ((_slicedMeshes[GetObjectIndex(_emptySpace)], _slicedMeshes[GetObjectIndex(targetCoordinate)]));

                _emptySpace = targetCoordinate;
                return true;
            }
            else
            {
                // print("failed to move");
            }

            return false;
        }

        private void Update()
        {
            // no button press
            if (!Input.GetMouseButtonDown(0))
                return;

            // can't move
            if (_slicedMeshes.FirstOrDefault(g => g.TryGetComponent(out GearOnSelect c) && c.selected && Move(c.data as LocationMeta)) is null)
                return;

            // is all complete?
            if (_slicedMeshes.All(g => g.TryGetComponent(out GearOnSelect c) && ((LocationMeta)c.data).isDefaultLocation()))
            {
                print("game over");
            }
        }
    }
}
